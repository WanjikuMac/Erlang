- module(geo).
- export([for/3, show/1, parse_name/1, parse_name_new/1, sum/1, test/1, map/2, cost/1,
  qsort/1, pytha/1, perms/1, area/1, startin/1, intersperse/2, zero_to_o/1, to_truncate/1, trim_after/2,
  trim_after_flat/2, flatten/1, value/2]).

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
    TruncateAfter = [$!, $", $#, $$, $%, $&, $(, $), $*, $+, $-, $/, $:, $;, $<, $=, $>, $?, $@, $], $., $\\],
                                                %truncate any values after the symbols above
    TruncatedValue = lists:takewhile(fun(X) -> not lists:member(X, TruncateAfter) end, Raw),
    Tokens = string:tokens(string:trim(TruncatedValue), " "),
                                                %Return the string without any member of the list below
    ToFilter = lists:map(fun string:casefold/1, ["I", "am", "Mimi", "jina", "Langu" "ni", "naitwa",
                                                 "1", "2", "3", "4", "5", "6", "7", "8", "9", "my", "name", "is", "jiunge", "join", "welcome", "yes", "40130", ""]),
    [H | _T] = lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter) end, Tokens),
    Value = lists:flatten(string:replace(H, "0", "o")),
    case Value of
        [Head | Tail] ->
            [string:to_upper(Head) | string:to_lower(Tail)];

        [] -> ("Rafiki~n")
    end.


%function to loop through all the symbols to truncate after
value(Raw, TrimAfter) ->
  lists:takewhile(fun(X) -> not lists:member(X, TrimAfter) end, Raw).
  %(lists:map(fun (X) -> case trim_after(Raw, X) == Raw of
                   % true -> [];
                    %false -> trim_after(Raw, X)
                   % end
               % end, TrimAfter)).


 %Trim =lists:map(fun(X) -> trim_after(Raw, X) == Raw end, [H|T]),
  %lists:filter(fun(X) -> X == false end, Trim).
%value_trim(Raw, [T]).

    %value_trim(V, []) -> V.

%trim_after(X, TrimAfter) -> trim_after_flat(lists:flatten(X), TrimAfter).
%trim_after_flat([C| Cs], TrimAfter) ->
%  case lists:member(C, TrimAfter) of
 %   false -> [C | trim_after(Cs, TrimAfter)];
  %  true -> []
  %end;
%trim_after_flat([], _) ->
 % [].


trim_after(X, TrimAfter) -> trim_after_flat(lists:flatten(X), TrimAfter).
trim_after_flat([H| T], TrimAfter) ->
  case lists:member(H, TrimAfter) of
    false -> [H | trim_after(T, TrimAfter)];
    true -> []
  end;
trim_after_flat([], _) ->
  [].



%Flatten a list and reverse it
flatten(X) -> lists:reverse(flatten(X, [])).

flatten([], Acc) -> Acc;
flatten([H|T],Acc) when is_list(H) -> flatten(T, flatten(H,Acc));
flatten([H|T], Acc) -> flatten(T, [H|Acc]).

%uppercase_head(lists:map(fun zero_to_o/1, Username)).
%uppercase_head([$o | Tail]) -> [$O | Tail]; uppercase_head(X) -> X.
%zero_to_o($0) -> $o; zero_to_o(x) -> x.


startin(Str1) ->
  Str3 = string:tokens(string:trim(Str1), " "),
  %Check_member = lists:member("I", Str3),
  ToFilter = lists:map(fun string:casefold/1,
                       ["I","am", "Mimi", ".", "jina", "Langu" "ni", "naitwa", "," , "+",
                "1", "2", "3", "4", "5", "6", "7", "8","9", "my", "name", "is", "40130"]),
  Filtered_list = lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter)end, Str3),
  io:format("~p~n", [Filtered_list]).

to_truncate(Name) ->
  V = lists:seq(1,100),
  Symbols =lists:flatten([$!, $@, $?, $/,V]),
  %Tokens = string:tokens(string:trim(Name), " "),
  %List_to_truncate =lists:map(fun (X) -> X end, Symbols),
  %List_to_truncate = ["!", "@", "?"],
  %Strip_off = lists:filter(fun (X) -> lists:member(X, List_to_truncate)end, Tokens),
 % [H] = Strip_off,
   string:trim(Name, trailing,Symbols ).
    %io:format("~p~n", [V]).

%trim_after(X, TrimAfter) -> trim_after_flat(lists:flatten(X), TrimAfter).

%trim_after_flat([C | Cs], TrimAfter) ->
 % case lists:member(C, TrimAfter) of
  %  false -> [C | trim_after(Cs, TrimAfter)];
   % true -> []
  %end;
%trim_after_flat([], _) ->
 % [].



% lists:map(fun (Z) -> string:replace(Z, "0", o)end, Z).

zero_to_o(0) -> o;
zero_to_o(x) -> x.

%spacing in between characters
intersperse([C], _) -> [C];
intersperse([C|Rest], Sep) -> [C | Sep] ++ intersperse(Rest, Sep).
