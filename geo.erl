- module(geo).
- export([for/3, show/1, parse_name/1, parse_name_new/1, sum/1, test/1, map/2, cost/1,
  qsort/1, pytha/1, perms/1, area/1, startin/1, intersperse/2, zero_to_o/1, to_truncate/1]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I) | for(I+1,Max, F)].

%sum([P]) ->
%    [H| T] -> [H + T];
 %   [] -> 0
  %end.

cost(oranges) -> 3;
cost(apples) -> 4;
cost(bananas) -> 9;
cost(mangoes) -> 5.

sum([H|T]) -> H + sum(T);
sum([]) -> 0.

%sum([H|T]) -> [H + sum(T)];
 % sum([]) -> 0.

%Returns the output of the written function after sorting the list.
map(_, []) -> [];
map(F, [H|T]) -> [F(H) | map(F, T)].


test(Buy) ->
  %Buy = [{oranges,1},{bananas,2},{mangoes,3}],
  F = [cost(A)* B || {A, B} <- Buy],
  %F = cost((A) * B || {A, B} <- Row),
  lists:sum(F).

pytha(N) ->
  [{A,B,C} ||
      A <- lists:seq(1,N),
      B <- lists:seq(1, N),
      C <- lists:seq(1, N),
    A + B + C =< N,
    A*A+B*B == C*C
  ].


  %area({circle, radius}) -> math:pi()* radius* radius;
  %area({triangle, base, height}) -> 1/2 * base *height;
  %area({perimeter, length, length}) -> length + length.

area({Object, Value}) ->
  case {Object,Value} of
  {circle, Value} -> math:pi()* Value* Value;
  %{triangle, Value, height} -> 1/2 * base *height;
  {perimeter, Value} -> Value + Value
  end.

perms([]) -> [[]];
perms(L) -> [[H | T] || H <- L, T <- perms(L--[H])].

show([P]) ->
    string:trim(P),
    io:format("~p~n", [P]),
    test_passed.

qsort([]) -> [];
qsort([Pivot | T]) -> qsort([X || X <- T, X< Pivot])
    ++ [Pivot] ++
    qsort([X || X <- T, X>= Pivot]).

parse_name(Raw) ->
  Tokens = string:tokens(string:trim(Raw), " "),
  case Tokens of
    [RawName | _] -> [H | T] = RawName,
                     [string:to_upper(H) | string:to_lower(T)];
    [] -> "Rafiki"
  end.

%parse_name_new(Raw) ->
 % Tokens = string:tokens(string:trim(Raw), " "),
  %ToFilter = lists:map(fun string:casefold/1,["I","am", "Mimi", ".", "jina", "Langu" "ni", "naitwa", "," "@", "+",
   % "1", "2", "3", "4", "5", "6", "7", "8","9", "my", "name", "is","$", "jiunge","join", "welcome", "yes"] ),
  %Filtered_List = lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter)end, Tokens),
  %case Filtered_List of
   % [RawName | _] -> [H| T] =  RawName,
    %  [string:to_upper(H) | string:to_lower(T)];
    %[] -> "Rafiki"
  %end.

parse_name_new(Raw) ->
  Tokens = string:tokens(string:trim(Raw), " "),
  ToFilter = lists:map(fun string:casefold/1,["I","am", "Mimi", ".", "jina", "Langu" "ni", "naitwa", "," "@", "+",
    "1", "2", "3", "4", "5", "6", "7", "8","9", "my", "name", "is","$", "jiunge","join", "welcome", "yes", "40130", ""] ),
  Filtered_List = lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter)end, Tokens),
  %io_lib:format("~s", Filtered_List),
  Value =  lists:flatten((string:replace(Filtered_List, "0", "o"))),
  case Value of
    [H| T] ->
      Final_string =[string:to_upper(H) | string:to_lower(T)],
      io:format("~p~n", [Final_string]);
      %io_lib:format("~s", [Final_string]);
    [] -> "Rafiki"
  end.


%uppercase_head(lists:map(fun zero_to_o/1, Username)).
%uppercase_head([$o | Tail]) -> [$O | Tail]; uppercase_head(X) -> X.
%zero_to_o($0) -> $o; zero_to_o(x) -> x.


startin(Str1) ->
  %Str1 = "I am Wanjiku",
  Str3 = string:tokens(string:trim(Str1), " "),
  %Check_member = lists:member("I", Str3),
  ToFilter = lists:map(fun string:casefold/1,
                       ["I","am", "Mimi", ".", "jina", "Langu" "ni", "naitwa", "," "@", "+",
                "1", "2", "3", "4", "5", "6", "7", "8","9", "my", "name", "is", "40130"]),
  Filtered_list = lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter)end, Str3),
  io:format("~p~n", [Filtered_list]),
  Value = lists:map(fun zero_to_o/1, Filtered_list),
  %Str2 = string:substr(Str1, 6,7),

  io:format("~p~n", [Value]).

to_truncate(Name) ->
  List_to_truncate = ["!", "@"],
                    V = iolist_to_binary(Name),
                    Result = string:trim( V, trailing, List_to_truncate),
                    io:format("~p~n",[Result]).


% lists:map(fun (Z) -> string:replace(Z, "0", o)end, Z).

zero_to_o(0) -> o;
zero_to_o(x) -> x.

%spacing in between characters
intersperse([C], _) -> [C];
intersperse([C|Rest], Sep) -> [C | Sep] ++ intersperse(Rest, Sep).