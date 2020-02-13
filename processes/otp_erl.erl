-module(otp_erl).
-export([bad_worker/0]).

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



	