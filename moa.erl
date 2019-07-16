-module(moa_info).
-export([sms_service/0, setup_db/0, write_invalid/8, sync_invalid_log/1, home_transformer/0]).

-import(survey_tk,
[keyword_rh/1, keyword_logic/1, listener/4]).

-spec home() -> activity:survey_elem().

home() ->
	listener(home,
		keyword_rh([{keywords:get_misspellings("FARM"), "farm"},
			{keywords:get_misspellings("SHAMBA"), "shamba"},
			{keywords:get_misspellings("CHECK"), "check"},
			{keywords:get_misspellings("ANGALIA"), "angalia"},
			{keywords:get_misspellings("MENU"), "menu"},
			{keywords:get_misspellings("ORODHA"), "orodha"},
			{keywords:get_misspellings("JOIN"), "join"},
			{keywords:get_misspellings("JIUNGE"), "jiunge"},
			{keywords:get_misspellings("TRUTH"), "truth"},
			{keywords:get_misspellings("KWELI"), "kweli"},
			{keywords:get_misspellings("QUIZ"), "quiz"},
			{keywords:get_misspellings("SWALI"), "swali"},
			{keywords:get_misspellings("ENGLISH"), "english"},
			{keywords:get_misspellings("SWAHILI"), "swahili"},
			{keywords:get_misspellings("CHIEF"), "chief"},
			{keywords:get_misspellings("SEED"), "seed"},
			{keywords:get_misspellings("MBEGU"), "mbegu"},
			{keywords:get_misspellings("FERTILIZER"), "fert"},
			{keywords:get_misspellings("MBOLEA"), "mbolea"},
			{keywords:get_misspellings("MAIZE"), "maize"},
			{keywords:get_misspellings("MAHINDI"), "maize"},
			{keywords:get_misspellings("BEAN"), "bean"},
			{keywords:get_misspellings("MAHARAGWE"), "bean"},
			{keywords:get_misspellings("POTATO"), "potato"},
			{keywords:get_misspellings("VIAZI"), "potato"},
			{keywords:get_misspellings("FAW"), "faw"},
			{keywords:get_misspellings("BUBAYI"), "bubayi"},
			{["END", "MWISHO"], "endweather"}]),
		keyword_logic([{"farm", {goto, registration, set_english}},
			{"shamba", {goto, registration, set_swahili}},
			{"check", {goto, monitoring, set_english}},
			{"angalia", {goto, monitoring, set_swahili}},
			{"menu", {goto, menu, set_english}},
			{"orodha", {goto, menu, set_swahili}},
			{"join", {goto, oaf_registration, set_english}},
			{"jiunge", {goto, oaf_registration, set_swahili}},
			{"truth", {goto, misconceptions, set_english}},
			{"kweli", {goto, misconceptions, set_swahili}},
			{"quiz", {goto, misconceptions_quiz, set_english}},
			{"swali", {goto, misconceptions_quiz, set_swahili}},
			{"english", {goto, language, set_english}},
			{"swahili", {goto, language, set_swahili}},
			{"chief", {goto, registration_chief, chief_welcome}},
			{"seed", {goto, seed, set_english}},
			{"mbegu", {goto, seed, set_swahili}},
			{"fert", {goto, fertilizer_tool, set_english}},
			{"mbolea", {goto, fertilizer_tool, set_swahili}},
			{"maize", {goto, menu, loccheckmaize}},
			{"bean", {goto, menu, loccheckbean}},
			{"potato", {goto, menu, loccheckpotato}},
			{"faw", {goto, menu, fawmenu}},
			{"endweather", {goto, weather_optin, set_optout}},
			{"bubayi", {goto, registration, set_bubayi}},
			{invalid, {goto, welcome, check_invalids}}]),
		home_transformer()).

-spec sms_service() -> service:paddy_service().

sms_service() ->
	{home(),
		[
			{registration, registration:registration()},
			{registration_chief, registration_chief:registration_chief()},
			{oaf_registration, oaf_registration:oaf_registration()},
			
			{menu, menu:menu()},
			{oaf_menu, oaf_menu:oaf_menu()},
			
			{monitoring, monitoring:monitoring()},
			{mon_from_reg, mon_from_reg:mon_from_reg()},
			
			{misconceptions, misconceptions:misconceptions()},
			{misconceptions_quiz, misconceptions_quiz:misconceptions_quiz()},
			
			{seed, seed:seed()},
			
			{fertilizer_tool, fertilizer_tool:fertilizer_tool()},
			{bean_solecrop_fert, bean_solecrop_fert:bean_solecrop_fert()},
			{maize_solecrop_fert, maize_solecrop_fert:maize_solecrop_fert()},
			{mz_be_intercrop_fert, mz_be_intercrop_fert:mz_be_intercrop_fert()},
			{irish_potato_fert, irish_potato_fert:irish_potato_fert()},
			
			{welcome, welcome:welcome()},
			{language, language:language()},
			{location, location:location()},
			{inbox_followups, inbox_followups:inbox_followups()},
			{referral_chief, referral_chief:referral_chief()},
			
			{maize_input_selection, maize_input_selection:maize_input_selection()},
			{maize_preplanting, maize_preplanting:maize_preplanting()},
			{maize_planting, maize_planting:maize_planting()},
			{maize_postplanting, maize_postplanting:maize_postplanting()},
			{maize_weeding_topdress1, maize_weeding_topdress1:maize_weeding_topdress1()},
			{maize_topdress2, maize_topdress2:maize_topdress2()},
			{maize_pest_push, maize_pest_push:maize_pest_push()},
			{maize_harvest, maize_harvest:maize_harvest()},
			{maize_harvest_push, maize_harvest_push:maize_harvest_push()},
			{maize_harvest2_push, maize_harvest2_push:maize_harvest2_push()},
			{maize_postharvest_menu_push, maize_postharvest_menu_push:maize_postharvest_menu_push()},
			{maize_postharvest1_handling, maize_postharvest1_handling:maize_postharvest1_handling()},
			{maize_postharvest2_salt_test, maize_postharvest2_salt_test:maize_postharvest2_salt_test()},
			{maize_postharvest4_storage_pest, maize_postharvest4_storage_pest:maize_postharvest4_storage_pest()},
			{maize_postharvest5_storage, maize_postharvest5_storage:maize_postharvest5_storage()},
			{maize_yield_questions, maize_yield_questions:maize_yield_questions()},
			
			{bean_planting, bean_planting:bean_planting()},
			{bean_postplanting, bean_postplanting:bean_postplanting()},
			{bean_crop_man_2, bean_crop_man_2:bean_crop_man_2()},
			{bean_pest1_beanfly, bean_pest1_beanfly:bean_pest1_beanfly()},
			{bean_pest2_aphids, bean_pest2_aphids:bean_pest2_aphids()},
			{bean_harvest_push, bean_harvest_push:bean_harvest_push()},
			{bean_postharvest_menu_push, bean_postharvest_menu_push:bean_postharvest_menu_push()},
			{potato_disease_control_menu_push, potato_disease_control_menu_push:potato_disease_control_menu_push()},
			{bean_harvest_question, bean_harvest_question:bean_harvest_question()},
			
			{potato_planting, potato_planting:potato_planting()},
			{potato_cropman1, potato_cropman1:potato_cropman1()},
			{potato_cropman2_ridging, potato_cropman2_ridging:potato_cropman2_ridging()},
			{potato_pest_lateblight, potato_pest_lateblight:potato_pest_lateblight()},
			{potato_pest_earlyblight, potato_pest_earlyblight:potato_pest_earlyblight()},
			{potato_harvest1, potato_harvest1:potato_harvest1()},
			{potato_harvest2, potato_harvest2:potato_harvest2()},
			{potato_crop_management_menu_push, potato_crop_management_menu_push:potato_crop_management_menu_push()},
			{potato_postharvest_menu_push, potato_postharvest_menu_push:potato_postharvest_menu_push()},
			{potato_postharvest_sorting, potato_postharvest_sorting: potato_postharvest_sorting()},
			{potato_postharvest_storing, potato_postharvest_storing: potato_postharvest_storing()},
			{potato_postharvest_storing_alternative, potato_postharvest_storing_alternative: potato_postharvest_storing_alternative()},
			
			
			{maize_optin, maize_optin:maize_optin()},
			{maize_optin_planting_preplanting, maize_optin_planting_preplanting:maize_optin_planting_preplanting()},
			{maize_optin_20190321, maize_optin_20190321:maize_optin_20190321()},
			{maize_monitoring_push, maize_monitoring_push:maize_monitoring_push()},
			{bean_optin_20190327, bean_optin_20190327:bean_optin_20190327()},
			{potato_optin, potato_optin:potato_optin()},
			{potato_optin_20190323, potato_optin_20190323:potato_optin_20190323()},
			{sleeper_push_20190426, sleeper_push_20190426:sleeper_push_20190426()},
			{monitoring_push_20190508,monitoring_push_20190508:monitoring_push_20190508()},
			
			{weather_optin, weather_optin:weather_optin()},
			{weather_20190305, weather_20190305:weather_20190305()},
			{weather_20190312, weather_20190312:weather_20190312()},
			{weather_20190313, weather_20190313:weather_20190313()},
			{weather_20190319, weather_20190319:weather_20190319()},
			{weather_20190326, weather_20190326:weather_20190326()},
			{weather_20190402, weather_20190402:weather_20190402()},
			{weather_20190409, weather_20190409:weather_20190409()},
			{weather_20190416, weather_20190416:weather_20190416()},
			{weather_20190423, weather_20190423:weather_20190423()},
			{weather_20190430, weather_20190430:weather_20190430()},
			{weather_20190507, weather_20190507:weather_20190507()},
			{weather_20190514, weather_20190514:weather_20190514()},
			{weather_20190521, weather_20190521:weather_20190521()},
			{weather_20190528, weather_20190528:weather_20190528()},
			{weather_20190604, weather_20190604:weather_20190604()},
			{weather_20190611, weather_20190611:weather_20190611()},
			{weather_20190618, weather_20190618:weather_20190618()},
			{weather_20190625, weather_20190625:weather_20190625()},
			{weather_20190702, weather_20190702:weather_20190702()},
			
			{oaf_menu_push_20190412, oaf_menu_push_20190412:oaf_menu_push_20190412()},
			{oaf_mon_push_20190418, oaf_mon_push_20190418:oaf_mon_push_20190418()},
			{oaf_misc_push_20190426, oaf_misc_push_20190426:oaf_misc_push_20190426()},
			{oaf_reregister_push_20190503, oaf_reregister_push_20190503:oaf_reregister_push_20190503()},
			{oaf_mon_push_20190503, oaf_mon_push_20190503:oaf_mon_push_20190503()},
			{oaf_menu_push_20190514, oaf_menu_push_20190514:oaf_menu_push_20190514()},
			{oaf_mon_push_20190521, oaf_mon_push_20190521:oaf_mon_push_20190521()},
			{oaf_mon_push_20190604, oaf_mon_push_20190604:oaf_mon_push_20190604()},
			{oaf_menu_push_20190611, oaf_menu_push_20190611:oaf_menu_push_20190611()},
			{oaf_quiz_push_20190625, oaf_quiz_push_20190625:oaf_quiz_push_20190625()},
			
			{tulaa_introduction, tulaa_introduction:tulaa_introduction()}
		]}.

-spec setup_db() -> [{aborted, term()} | {atomic, ok}].

setup_db() ->
	paddy:setup_db() ++
		at_send:setup_db() ++
		at_receive:setup_db() ++
		[fifo:init_queue(invalid_log_fifo)].

-spec home_transformer() -> activity:transformer_spec().

% Stores invalid responses in inbox, ignores others
% Maintains counter for consecutive invalid messages to not waste messages on spammers
home_transformer() ->
	{context_input_transformer,
		fun (Context, _Raw, ParsedResp) ->
			case ParsedResp of
				{invalid, {Type, Args, Raw, Reason}} ->
					log_invalid({invalid_log, fifo:get_time_micro(), st:get_uid(Context),
						Raw, Type, Args, Reason, st:get_env(Context), home}),
					{on_state,
						fun (InvalidCount) ->
							case InvalidCount of
								empty -> 1;
								_Other -> InvalidCount + 1
							end
						end,
						{invalid_count}};
				_Other -> {on_state, fun (_InvalidCount) -> 0 end, {invalid_count}}
			end
		end}.

log_invalid(InvalidLog) ->
	fifo:add_to_queue(invalid_log_fifo, InvalidLog).

-spec write_invalid(calendar:datetime(), string(), string(), atom(), term(), term(), [atom()], atom()) ->
	epgsql:reply(epgsql:equery_row()) | {error, Reason :: any()}.

write_invalid(TS, Phone, Message, Type, _Args, Reason, Survey, Question) ->
	db_sync:upsert_values("invalid", ["phone", "msg_ts"],
		["phone", "msg_ts", "msg", "type", "reason", "env", "question"],
		[Phone, TS, Message, Type, Reason, Survey, Question]).

sync_invalid_log({invalid_log, TS, Phone, Message, Type, Args, Reason, Survey, Question}) ->
	write_invalid(TS, Phone, Message, Type, Args, Reason, Survey, Question).
