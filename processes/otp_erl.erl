-module(otp_erl).
-export([bad_worker/0, good_worker/0, spawn_worker/0]).

bad_worker() ->
	receive
		{add, V1, V2} ->
			erlang:display(V1+V2);
		{sub, V1,V2} ->
			erlang:display(V1-V2);
		{mul, V1,V2} ->
			erlang:display(V1*V2);
		{square, V1} ->
			erlang:display(V1*V1);
		anything_else -> erlang:display("I don't know how to handle this")
	end.

good_worker() ->
	receive
		{add, V1, V2} ->
			erlang:display(V1+V2),
			good_worker();
		{sub, V1,V2} ->
			erlang:display(V1-V2),
			good_worker();
		{mul, V1,V2} ->
			erlang:display(V1*V2),
			good_worker();
		{square, V1} ->
			erlang:display(V1*V1),
			good_worker();
		anything_else -> erlang:display("I don't know how to handle this"),
			good_worker()
	end.

spawn_worker() ->
	P_Bad = spawn(otp_erl, bad_worker, []),
	P_Good = spawn(otp_erl, good_worker, []),
	P_Bad ! {add, 2,3},
	P_Bad ! {sub, 3,2},
	P_Good ! {add, 3,2},
	P_Good ! {sub, 3,2},
	P_Good ! {mul, 3,2},
	P_Good ! anything_else,
	P_Good ! {square,4}.
	