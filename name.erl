-module(name).

-import(string, [len/1]).
-import(lists, [min/1, max/1]).

-export([uname/0, double/1, f2c/1, c2f/1, convert/2, area/1, list1/1,
   max_num/1, min_max/1]).

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


