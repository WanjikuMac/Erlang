-module(test_try).
-export([fib/1]).

%function should generate the fibonacci sequence 
% generate_fibonacci(Values) ->  generate_fibonacci([Values, 1]).

% generate_fibonacci([], List) -> List;
% generate_fibonacci([H, V | T], _List) -> generate_fibonacci(T, H+V).

%fib(A, B) -> [A | fun () -> fib(B, A + B) end].
%fib() -> fib(0, 1).

fib(0) -> 1;
fib(1) -> 1;
fib(N) ->
    fibonacci(0, N, fib(0), fib(1)).
fibonacci(N, T, N_2, _) when N == T ->
    N_2;
fibonacci(N, _, _, _) when N < 0 ->
    false;
fibonacci(N, T, N_2, N_1) ->
    fibonacci(N + 1,  T,  N_1,  N_2 + N_1).