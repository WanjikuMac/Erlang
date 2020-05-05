-module(test_try).
-export([fib/1]).

fib(0) -> 1;
fib(1) -> 1;
fib(N) ->
    fibonacci(0, N, fib(0), fib(1)).
fibonacci(N, T, N_2, _) when N == T ->
    N_2;
fibonacci(N, _, _, _) when N < 0 ->
    false;
fibonacci(N, T, N_2, N_1) ->
    io:format("Value of T: ~p", [T]),
    fibonacci(N + 1,  T,  N_1,  N_2 + N_1).