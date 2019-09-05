-module(exercise_test).

-export([setup_db/0, add_abuse/2, add_tips/3, add_users/3, read_info/1, read_info_abuse/1, read_info_tips/1]).

-record(users, {name, email_address :: string(), password}).
-record(tips, {site_url, description, date_of_review}).
-record(abuse, {ip_address, number_of_site_visits}).

setup_db()->

mnesia:create_table(users,[{attributes, record_info(fields, users)},{disc_copies, [node()]}]),
mnesia:create_table(tips, [{attributes, record_info(fields, tips)}, {disc_copies, [node()]}]),
mnesia:create_table(abuse, [{attributes, record_info(fields, abuse)}, {disc_copies, [node()]}]).

%Routines to write to the tables

add_users(Name, Email, Password) ->
	Row = #users{name = Name, email_address = Email, password = Password},
	F = fun() ->
				mnesia:write(Row)
			end,
	mnesia:transaction(F).

add_tips(Url, Desc, Date) ->
	Row = #tips{site_url = Url, description = Desc, date_of_review = Date},
	F = fun() ->
		mnesia:write(Row)
			end,
	mnesia:transaction(F).

add_abuse(IP, Visit) ->
	Row = #abuse{ip_address = IP, number_of_site_visits = Visit},
	F = fun() ->
		mnesia:write(Row)
			end,
	mnesia:transaction(F).

read_info(Username) ->
	F = fun () ->
		mnesia:read({users, Username})
			end,
	mnesia:transaction(F).

read_info_abuse(Name) ->
	F = fun () ->
		mnesia:read({abuse, Name})
	    end,
	mnesia:transaction(F).

read_info_tips(Url) ->
	F = fun () ->
		mnesia:read({tips, Url})
	    end,
	mnesia:transaction(F).