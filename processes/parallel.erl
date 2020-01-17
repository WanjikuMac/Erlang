-module(parallel).
-export([test/1]).

test(Number) ->
	MyPID = self(),
	io:format("~p~n", [MyPID]),
	spawn(fun() -> double(MyPID, Number)end),
	receive
		{answer, Val} -> {"Child process said", Val}
	end.

double(Parent, Number) ->
	Result = Number *2,
	Parent ! {answer, Result}.