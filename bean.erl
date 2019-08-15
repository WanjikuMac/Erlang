%%% @doc
%%% Bean crop management survey on weed control -- cropping series
%%% @end
-module(bean_crop_man_2).
-export([bean_crop_man_2/0]).

-import(survey_tk,
[calculation/2, depends/2, dynamic/1, engswa/2,
raw_rh/0, keyword_rh/1, yesno_rh/0, fractional_range_rh/2, integer_range_rh/2,
save_as/1,
send_airtime/1,
next/1, next_or_timeout/2, next_or_invalid/2, next_invalid_timeout/3,
keyword_logic/1,
listener/3, question/5,
final_message/2, quiet_ending/1, dummy_message/3]).


-spec bean_crop_man_2() -> service:paddy_app().

bean_crop_man_2() ->
	[
		question(beanesm,   %If OPTED-IN to Bean series
			engswa("Welcome to MoA-INFO's Grow Better Beans service. Would you like to receive advice on controlling weeds in your bean fields?\nA. Yes\nB. No",
				"Karibu kwa huduma ya MoA-INFO ya upanzi bora wa maharagwe. Je, ungependa kupokea ushauri wa kuzuia magugu kwa shamba la maharagwe?\nA. Ndio\nB. La"),
			24*60,
			yesno_rh(),
			keyword_logic([{"yes", beanesm1},
				{"no", beanno},
				{invalid, expire},
				{timeout, beanesmr}])),
		
		question(beanesmr,
			engswa("Hello again from MoA-INFO. Receive advice on controlling weeds in your bean field now!\nA. Yes\nB. No",
				"Hujambo tena kutoka MoA-INFO. Pokea ushauri wa jinsi ya kuzuia magugu kwa shamba lako la  maharagwe sasa!\nA. Ndio\nB. La"),
			24*60,
			yesno_rh(),
			keyword_logic([{"yes", beanesm1},
				{"no", beanno},
				{invalid, expire},
				{timeout, expire}])),
		
		final_message(bmenupsh,    %If OPTED-IN to bean AND maize series AND cohort 1--One push message.
			engswa("Welcome back to MoA-INFO's Grow Better Beans service. Reply BEAN to access advice on crop management and other topics for bean farmers.",
				"Karibu tena kwa huduma ya MoA-INFO ya upanzi bora wa maharagwe. Jibu MAHARAGWE kupata ushauri ya utunzaji wa mimea na mada zingine kwa wakulima wa maharagwe.")),
		
		bean_weed_control:bean_weed_control(beanthx),
		final_message(beanthx,
			engswa("Thanks for using MoA-INFO's Grow Better Beans service. We'll be following up with bean management in the coming weeks.",
				"Asante kwa kutumia huduma ya MoA-INFO ya upanzi bora wa maharagwe. Tutafuatilia na ushauri wa kutunza maharagwe shambani wiki zijazo.")),
		
		final_message(beanno,
			engswa("Thanks for letting us know. We'll follow up in coming weeks with other topics related to bean farming.",
				"Asante kwa kutujulisha. Tutafuatilia katika wiki zijazo na mada zingine kuhusu kilimo cha maharagwe.")),
		
		quiet_ending(expire)
	].
