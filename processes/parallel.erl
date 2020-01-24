-module(parallel).
-export([test/1, test_inner/1, test_trial/1, add_child/0]).

test_inner(0) ->
	io:format("Reached 0~n", []),
	ok;
test_inner(Number) ->
	io:format("~p~n", [Number]),
	timer:sleep(1000),
	test_inner(Number -1).

test_trial(Number) ->
			{ok, spawn_link(parallel, test_inner, [Number])}.

add_child() ->
	supervisor:start_child(my_sup, [3]).


test(Number) ->
	MyPID = self(),
	io:format("~p~n", [MyPID]),
	PID = {ok, spawn(fun() -> double(MyPID, Number)end)},
	io:format("~p~n", [PID]),
	receive
		{answer, Val} -> {"Child process said " , Val}
	end.

double(Parent, Number) ->
	Result = Number *2,
	Parent ! {answer, Result}.