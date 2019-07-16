%%% @doc
%%% This module tracks how many times the system has sent messages to the user and whether the have responded
%%% then based on that you query them on whether they need any keep getting the messages or they can opt out
%%% @end
-module(maize_harvest_push).
-export([maize_harvest_push/0]).

-import(survey_tk,
[engswa/2,
raw_rh/0, yesno_rh/0, keyword_rh/1, fractional_range_rh/2, integer_range_rh/2,
save_as/1, inc_counter/1, set_var/2,
send_airtime/1,
next/1, next_or_timeout/2,
keyword_logic/1, depends/2,
listener/3, question/5,
final_message/2, quiet_ending/1, dummy_message/3]).

-spec maize_harvest_push() -> service:paddy_app().

maize_harvest_push() ->
	maize_optout_module(
		% Intro message
		engswa("Welcome back to MoA-INFO's Grow Better Maize messaging service. Would you like to learn about proper timing of your maize harvest?\nA. Yes\nB. No",
			"Karibu tena kwa huduma ya MoA-INFO ya upanzi bora wa mahindi. Je, ungependa kujifunza jinsi ya kujua wakati sahihi wa kuvuna mahindi yako?\nA. Ndio\nB. La"),
		% Reminder message
		engswa("Hello again from MoA-INFO. Reply now to receive harvest timing advice for maize!\nA. Yes\nB. No",
			"Hujambo tena kutoka MoA-INFO. Chukua hatua sasa ili upokee ushauri wa wakati wa kuvuna mahindi!\nA. Ndio\nB. La"),
		% Message series
		maize_harvest_timing:maize_harvest_timing(mzthanx),
		% Start of message series
		mzhartim1,
		% Final message after content
		engswa("Thanks for using MoA-INFO's Grow Better Maize service. We will follow-up in coming weeks with more harvest and post-harvest tips.",
			"Asante kwa kutumia huduma ya MoA-INFO ya upanzi bora wa mahindi. Tutafuatilia wiki zijazo na vidokezo zaidi vya kuvuna na baada ya kuvuna."),
		% Final message after user says no to content
		engswa("Thanks for letting us know. We will follow-up in coming weeks with more harvest and post-harvest tips.",
			"Asante kwa kutujulisha. Tutafuatilia wiki zijazo na vidokezo zaidi vya kuvuna na baada ya kuvuna.")
	).

maize_optout_module(MsgIntro, MsgIntroR, Series, SeriesStart, Thanks, Reject) ->
	[
		%Maize optin questions.
		question(welblst,
			MsgIntro,
			24*60,
			yesno_rh(),
			keyword_logic([{"yes", reset_maize_idle1},
				{"no", increment_maize_idle},
				{invalid, expire},
				{timeout, welblstr}])),
		
		question(welblstr,
			MsgIntroR,
			24*60,
			yesno_rh(),
			keyword_logic([{"yes", reset_maize_idle1},
				{"no", increment_maize_idle},
				{invalid, expire},
				{timeout, increment_maize_idle}])),
		
		%If yes to the optin question.
		dummy_message(reset_maize_idle1,
			set_var({maize_idle_count}, 0),
			next(SeriesStart)),
		
		Series,
		
		%If no or expiry to the optin question.
		%increment the idle counter
		dummy_message(increment_maize_idle,
			inc_counter({maize_idle_count}),
			next(maize_optout_question_selector)),
		
		%decide if to ask optout (either hard or soft)
		dummy_message(maize_optout_question_selector,
			none,
			depends(
				[{maize_idle_count}, welblst, welblstr],
				fun (Count, Optin1, Optin2) ->
					case Count of
						Num when Num >=5  	-> next(maize_optout_hard);
						Num when Num >=3  	-> next(maize_optout_soft);
						_ ->
							case Optin1=="no" orelse Optin2=="no" of
								true	-> next(maizeno);
								false	-> next(expire)
							end
					end
				end)),
		
		%Optout questions
		question(maize_optout_soft,
			engswa("Would you like to stop receiving regular maize cropping advice messages this season?\nA. Yes\nB. No",
				"Ungependa kuacha kupokea ushauri mara kwa mara wa upanzi wa mahindi msimu huu?\nA. Ndio\nB. La"),
			24*60,
			yesno_rh(),
			keyword_logic([{"yes", set_maize_optout},
				{"no", reset_maize_idle2},
				{invalid, expire},
				{timeout, expire}])),
		
		%note: in this message the text says how many messages have been ignored
		question(maize_optout_hard,
			engswa("We've noticed that you have not responded to the last 5 MoA-INFO Grow Better Maize messages. Reply A to continue receiving these messages this season.",
				"Tumegundua kuwa hujajibu maswali matano ya mwisho ya huduma ya MoA-INFO ya upanzi bora wa mahindi. Jibu A kuendelea kupokea ujumbe huu msimu huu."),
			24*60,
			raw_rh(),
			next_or_timeout(reset_maize_idle2,set_maize_optout)),
		
		%If user elects to not optout then reset idle counter to zero"
		dummy_message(reset_maize_idle2,
			set_var({maize_idle_count}, 0),
			next(maize_continue_message)),
		
		dummy_message(set_maize_optout,
			set_var({maize_optin}, "no"),
			next(maize_optout_message)),
		
		%Final questions
		%1 - if user has seen content.
		final_message(mzthanx,
			Thanks),
		%2 - if user does not see content, and is not asked about opting out.
		final_message(maizeno, Reject),
		%If user is asked to optout and does.
		final_message(maize_optout_message,
			engswa("Thanks. You can still receive our maize cropping advice by sending MENU to 40130 anytime.",
				"Asante. Bado unaweza kupokea ushauri wetu wa upanzi wa mahindi kwa kutuma neno ORODHA kwa 40130 wakati wowote.")),
		%If user is asked to optout and does not.
		final_message(maize_continue_message,
			engswa("Thanks. You will continue receiving our regular maize messages.",
				"Asante. Utaendelea kupokea ujumbe wetu wa mara kwa mara kuhusu mahindi.")),
		
		quiet_ending(expire)
	]).