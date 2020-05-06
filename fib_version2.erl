-module(fib_version2).
-export([main/0, fib/3]).

main() ->
    Answer = fib(2,1,0),
    io:format("Answer ~p~n", [Answer]).

fib(A, B, S) when A >= 100, B rem 2 =:= 0 -> B + S;
%io:format("A: ~p~n B: ~p~n C: ~p~n", [A, B, S]);
fib(A, _, S) when A >= 100 -> S;
fib(A,B,S) when B rem 2 =:= 0 -> fib(A +B, A, B+S);
fib(A,B,S) -> fib(A +B, A, S).