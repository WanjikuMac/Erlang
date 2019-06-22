-module(name).

-import(string, [len/1]).
-import(lists, [min/1, max/1]).

-export([uname/0, double/1, f2c/1, c2f/1, convert/2, area/1, list1/1,
   max_num/1, min_max/1, even/0, odd/0, math_fun/1, filter/2, filter_two/1,
  filter_element/1, split/1]).

uname()->
   io:fwrite(" Hello\n ", []).

double(N) ->
   io:format("~p\n", [N]).

f2c(F) ->
   (F - 32) * 5/9.
c2f(C) ->
   (C * 9/5) +32.
convert(From, What) ->
      case {From, What} of
         {c,What} -> c2f(What);
         {f, What} -> f2c(What);
         {_, _ } -> io:format("incorrect format~n")
      end.

area({square, Side}) ->
   Side* Side;

area({circle, Radius}) ->
   math:pi()* Radius * Radius;

area({triangle, A, B,C}) ->
   S = (A + B + C)/2,
   math:sqrt(S*(S-A)*(S-B)*(S-C));

area(_other) ->
   {error, invalid_object}.

list1(Passed_list) ->
   min(Passed_list).
max_num(Max_list) ->
   max(Max_list).
min_max(L) ->
   A = list1(L),
   B = max_num(L),
   io:format("~p, ~p\n", [A, B]).


%This function takes in a number, checks if it's even or odd and returns
% the respective response.
math_fun(X) ->
  Z = lists:map(even(),X),
   io:format("~p~n", [Z]),
   Y = lists:map(odd(), X),
   io:format("~p~n", [Y]).


filter(_, []) -> [];
filter(F, [H|T]) -> [F(H) | filter(F ,T)].
  %lists:filter(fun(X) -> X rem 3 == 0 end, L).

%returns true for the values are true
filter_two(L) ->
 Z = lists:map(even(),L),
  lists:filter(fun(X) -> X == true end, Z).
%returns elements which evaluate to true
filter_element(L) ->
  lists:filter(even(), L).

split(L) ->
  Q = lists:map(even(), L),
  Z = lists:filter(fun(X) -> X == true end, Q) ++ lists:filter(fun(X) -> X == false end, Q),
    V = lists:partition(fun(A) -> A == true end, Z).
  tuple_to_list(V)
  %lists:member(L, lists:filter(even(), L)).
    %lists:filter(even(), L).
   %lists:map(fun(X) -> lists:filter(even(), X), L).

even() -> fun(X) -> (X rem 2 )== 0 end.
odd() -> fun(X) -> (X rem 2) =/= 0 end.
%math_fun() ->

