%%% @doc
%%% This module tracks how many times the system has sent messages to the user and whether the have responded
%%% then based on that you query them on whether they need any keep getting the messages or they can opt out
%%% @end
-module(optin).
-export([to_minute/1, survey_encompasses_minute/2, pred/2]).

-spec to_minute(datetime_micro()) -> calendar:datetime().
-type datetime_micro() :: {{integer(), integer(), integer()}, {integer(), integer(), integer() | float()}}.


to_minute({Date, {HH, MM, _SS}})->
	{Date, {HH, MM, 0}}.

survey_encompasses_minute({open, Values}, DateTime) ->
	case proplists:lookup(opened, Values) of
		none -> false;
		{opened, OpendDT} -> to_minute(OpendDT) =< DateTime,
			io:format("st_sync found unexpected value for Fields ~n")
	end.

pred(X, Y) ->
	SUM = X +Y,
	io:format("st_sync found unexpected value for Fields ~n"),
		SUM.

	

