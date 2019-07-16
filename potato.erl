-module(potato_postharvest_menu_push).
-export([potato_postharvest_menu_push/0]).

-import(survey_tk,
[calculation/2, depends/2, dynamic/1, engswa/2, inc_counter/1, set_var/2, set_var_random/2,
raw_rh/0, keyword_rh/1, yesno_rh/0, fractional_range_rh/2, integer_range_rh/2,
save_as/1,
send_airtime/1,
next/1, next_or_timeout/2, next_or_invalid/2, next_invalid_timeout/3,
keyword_logic/1,
listener/3, question/5,
final_message/2, quiet_ending/1, dummy_message/3, add_reminder/1]).


-spec potato_postharvest_menu_push() -> service:paddy_app().

potato_postharvest_menu_push() ->
	[
		add_reminder(question(menupotatohphwelcomeback,
			engswa("Welcome back to MoA-INFO. Please select a topic about Irish potato post-harvest:\nA. Sorting\nB. Storage\nC. Storing in heaps",
				"Karibu tena kwa MoA-INFO. Tafadhali chagua mada ya baada ya kuvuna viazi (waru):\nA. Kuchagua\nB. Hifadhi\nC. Kuhifadhi kwa matuta"),
			24*60,
			keyword_rh([{["A", "1", "Sorting", "Kuchagua"], "IP Sorting"},
				{["B", "2", "Storage", "Hifadhi"], "IP Storage"},
				{["C", "3", "Storing in heaps", "Kuhifadhi kwa matuta"], "IP Storage Heaps"},
				{["#", "Back", "Kurudi"], "IP HPH Back"}]),
			keyword_logic([{"IP Sorting", {goto, menu, potpoha1}},
				{"IP Storage", {goto, menu, potsto1}},
				{"IP Storage Heaps", {goto, menu, potend1}},
				{"IP HPH Back", {goto, menu, menupotatoreg}},
				{invalid, expire},
				{timeout, expire}]))),
		
		quiet_ending(expire)
	
	].
