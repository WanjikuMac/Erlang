- module(geo).
- export([for/3, show/1, parse_name/1, parse_name_new/1, sum/1, test/1, map/2, cost/1, summarize/1,get_time_micro/0,
          qsort/1, pytha/1, perms/1, area/1, startin/1, intersperse/2, zero_to_o/1, to_truncate/1, trim_after/2,
          trim_after_flat/2, flatten/1, value/1, many/1, greet/2, head/1, same/2, valid_time/1, old/1, fine_if/1,name_resp/1,
          help_me/1, insert/2, calculation/2, round/2, optout_question_selector/5, letters/0, list/1, all_fun/1, is_string/1]).
- export([add/2, one/0, two/0, increment/1, decrement/1]).
- export([map1/2, incr/1,decre/1, prep/1, base/1, base/0]).
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
                                                %Test this data
                                                %"Gideon.",
                                                %"Peter\n",
                                                %"Karibu kwa MoA-INFO, huduma ya mawaidha ya Wizara ya Kilimo. Huduma hii ni ya kutuma na kupokea ujumbe bila malipo. Jina lako la kwanza ni nani",
                                                %"Welcome to MoA-INFO, the Ministry of Agriculture's information service. It's free to send and receive every SMS. What is your first name",

parse_name_new(Raw) ->
    TruncateAfter = [$!, $", $#, $$, $%, $&, $(, $), $*, $+, $-, $/, $:, $;, $<, $=, $>, $?, $@, $], $., $\\, $,],
                                                %truncate any values after the symbols above
    TruncatedValue = lists:takewhile(fun(X) -> not lists:member(X, TruncateAfter) end, Raw),
    Tokens = string:tokens(string:trim(TruncatedValue), " "),
                                                %Return the string without any member of the list below
    ToFilter = lists:map(fun string:casefold/1, ["I", "am", "Mimi", "jina", "Langu", "ni", "naitwa", "", "Shamba", "Farm", "Mr", "Mrs.", "Mrs",
                                                 "1", "2", "3", "4", "5", "6", "7", "8", "9", "my", "name", "is", "jiunge", "join", "welcome", "yes", "40130", ""]),
    FilteredList= lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter) end, Tokens),
                                                %Remove any integer from the filtered list
    DropInteger = lists:filter(fun (X) -> not lists:all(fun (A) -> A >= $0 andalso A =< $9 end, X)end, FilteredList),
    io:format("~p~n", [DropInteger]),
                                                %V = length(DropInteger),
    case DropInteger of
        [[_W]| _Z ] -> empty;
        [H | _T] -> [Head|Tail] = lists:flatten(string:replace(H, "0", "o")),
                    [string:to_upper(Head) | string:to_lower(Tail)];
        [] -> empty
    end.

all_fun(Val) ->
  case Val of
    Val  -> "yes"
  end.

is_string([C|T]) when (C >= 0) and (C =< 255) ->
  is_string(T);
is_string([]) ->
  true;
is_string(_) ->
  false.

greet(male, Name) ->
    io:format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) ->
    io:format("Hello, Mrs. ~s!~n", [Name]);
greet(_, Name) ->
    io:format("Hello, ~s!", [Name]).

head([_I, H| _T]) -> H.

%guards
old(X) when X >= 16, X =< 104 -> true;
old(_) -> false.
summarize(_) ->
  fun (Initial, Reminder, _DOI)when Initial == "yes" orelse Reminder == "yes" ->
  "accepted";
  (Initial, Reminder, _DOI) when Initial == "no" orelse Reminder == "no" ->
  "declined";
  (Initial, Reminder, _DOI) when Initial == timeout orelse Reminder == timeout ->
  "ignored"
  end
.
  
%if expression
fine_if(N) ->
  if N =:=1 ->
    works;
    true -> issa_lie
  end.

help_me(Animal) ->
  Talk =if Animal == cat -> "meow";
    Animal == cow -> "mooo";
    Animal == horse -> "neigh";
    Animal == dog -> "barks";
    true -> "hahaha"
  end,
  {Animal, "says " ++ Talk ++ "!"}.

insert(X, []) ->
  [X];
insert(X, Set) ->
 case lists:member(X, Set) of
    true -> Set;
    false -> [X | Set]
  end.


%calculation(List) ->
  %List  = [1,2, any],
  
  %case List of
    %[_V, S |_Rest] -> S/10;
    %[H |_T] -> H/10
  %end.
calculation([], _) ->
  [];
calculation(_, []) ->
  [];
calculation([A |As], [B |Bs]) ->
  [{A,B}| calculation(As,Bs)].

letters() ->
  lists:map(fun (G) -> [G] end, lists:seq($A, $Z)).

round(Number, Precision) ->
  P = math:pow(10, Precision),
  round(Number * P) / P.

%Option 1
optout_question_selector(Value, Optin, Optin2, Soft, Hard) ->
      case Value of
        Value when Value >= Hard  -> "The hardoptout";
        Value when Value >= Soft  -> "The softoptout";
        _ ->
          case Optin == "Yes" orelse  Optin2 =="no" of
              true  -> "Thankyou we shall keep you posted";
              false -> "expire quietly "
          end
      end.
list([])     -> [];
list([Elem]) -> [Elem];
list(List)   -> list(List, length(List), []).

list([], 0, Result) ->
  Result;
list(List, Len, Result) ->
  {Elem, Rest} = nth_rest(random:uniform(Len), List),
  list(Rest, Len - 1, [Elem|Result]).

nth_rest(N, List) -> nth_rest(N, List, []).

nth_rest(1, [E|List], Prefix) -> {E, Prefix ++ List};
nth_rest(N, [E|List], Prefix) -> nth_rest(N - 1, List, [E|Prefix]).

% Option 2
%set_soft_optout(Soft) ->
 % Soft.
%set_hard_optout(Hard) ->
 % Hard.


same(X,X) ->
    true;
same(_,_) ->
    false.
valid_time({Date ={Y,M,D}, Time = {H,Min,S}}) ->
  io:format("The date tuple (~p) says today is: ~p/~p/~p,~n", [Date,Y,M,D]),
  io:format("The time tuple (~p) indicates: ~p:~p:~p~n", [Time, H,Min,S]);
valid_time(_) ->
  io:format("Stop feeding me wrong data!~n").

many(X) ->
    case X of
        [] ->
            none;
        [ _One, _Two] ->
            two;
        [ _One ] ->
            one;
        [ _One, _Two , _Three | _Tail ] ->
            many
    end.
                                                %case Value of
                                                %[Head | Tail] ->
                                                %   [string:to_upper(Head) | string:to_lower(Tail)];

                                                %[] -> "Rafiki"
                                                %end.


                                                %function to loop through all the symbols to truncate after
value(Raw) ->
                                                %lists:all(fun erlang:is_integer/1, "123").
                                                %X = lists:seq(1,100),
    Tokens = string:tokens(string:trim(Raw), " "),
                                                % V = fun (D) -> D >= $0 andalso D =< $9 end,
    Z = lists:filter(fun(X) -> not lists:all(fun (D) -> D >= $0 andalso D =< $9 end, X)end, Tokens),
                                                %Z = lists:filter(fun(X) -> lists:all(fun(A) -> is_integer(A)end, X) end, Tokens),
                                                %V = lists:all(fun(X) -> is_integer(X)end, "123"),
    io:format("~p~n", [Tokens]),
    io:format("~s~n", [Z]).

                                                %lists:dropwhile(fun(X) ->lists:seq(X,100) end, Raw).
                                                %[H |T] =string:tokens(string:trim(Raw), " "),
                                                %case lists:dropwhile(fun(X) -> is_integer(X)end, H) of
                                                % [] -> T;
                                                %_ -> Raw
                                                %end.

                                                % TruncatedValue = lists:takewhile(fun(X) -> not lists:member(X, TrimAfter) end, Raw),
                                                %TruncatedValue1 = tuple_to_list(lists:splitwith(fun(A) -> lists:member(A, TrimAfter) end, Raw)),
                                                %      io:format("~p~n",[TruncatedValue]),
                                                %     io:format("~p~n",[TruncatedValue1]).
                                                %string:tokens(string:trim(TruncatedValue), " ").


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


-spec get_time_micro() -> {{integer(), integer(), integer()}, {integer(), integer(), float()}}.

get_time_micro() ->
  Timestamp = erlang:timestamp(),
  {_, _, Micro} = Timestamp,
  {Date, {HH, MM, SS}} = calendar:now_to_universal_time(Timestamp),
  {Date, {HH, MM, SS + Micro * 0.000001}}.

%name resp handler version two
name_resp(Raw) ->
  TruncateAfter = [$!, $", $#, $$, $%, $&, $(, $), $*, $+, $-, $/, $:, $;, $<, $=, $>, $?, $@, $], $., $\\],
  %truncate any values after the symbols above
  TruncatedValue = lists:takewhile(fun(X) -> not lists:member(X, TruncateAfter) end, Raw),
  io:format("~p~n", [TruncatedValue]),
  Tokens = string:tokens(string:trim(TruncatedValue), " "),
  io:format("~p~n", [Tokens]),
  %Return the string without any member of the list below
  ToFilter = lists:map(fun string:casefold/1, ["I", "am", "Mimi", "jina", "Langu" , "ni", "naitwa","FARM","shamba", " Mr.",
    "my", "name", "is", "jiunge", "join", "welcome", "yes", "40130"]),
  FilteredList= lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter) end, Tokens),
  
  %Drop any integers present
  DropInteger = lists:map(fun (X) -> lists:filter(fun(A) -> A < $0 orelse A > $9 end, X)end, FilteredList),
  io:format("~p~n", [DropInteger]),
  
  FinalFilter = lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter) end, DropInteger),
  case FinalFilter of
    %Return rafiki if the name contains one character
    [[_W]| _Rest] -> "Rafiki";
    
    %return Tail value when head is empty
    [[] | T] ->[Head|Tail] = lists:flatten(string:replace(T, "0", "o")),
      [string:to_upper(Head) | string:to_lower(Tail)];
    
    %Return name if the it contains more than one character
    [H| _T] -> [Head|Tail] = lists:flatten(string:replace(H, "0", "o")),
      [string:to_upper(Head) | string:to_lower(Tail)];
    [] -> "Rafiki"
  end.

one() -> 1.
two() -> 2.

%To compile this, run the following geo:add(fun geo:one/0, fun geo:two/0)
add(X,Y) -> X() + Y().

increment([]) -> [];
increment([H | T]) -> [H + 1 | increment(T)].

decrement([]) -> [];
decrement([H | T]) -> [H -1 |decrement([T])].


%abstraction
map1(_, []) -> [];
map1(F, [H|T]) -> [F(H) | map1(F, T)].

incr(X) -> X +1.
decre(X) -> X - 1.

base(A) ->
  B =A +1,
  F = fun() -> A * B end,
  F().

prep =
  fun(Room) ->
io:format("Alarm set in ~s. ~n", [Room]),
fun () -> io:format("Alarm tripped in ~s! call Batman! ~n", [Room]) end
end.

base() ->
  A = 1,
  (fun(A) -> A = 2 end)(2).

% UpdateFname =
%   fun ({user_vars, UserData}) ->
%      {user_vars, lists:map(CleanUp, UserData)};
% ({Label, Content}) ->
%    {Label, Content}
%end,



%when Var == first_name ->

%case {user_var, lists:map(fun({Var, Val}) -> Var == first_name end, Data)} of
%   true -> {user_var, {Var, name_resp(Val)}};

%case ({Fname, Value}) of
%   fun ({Var, Val}) when {Var} == first_name ->
%       name_resp(Val);
%  ({Var, Val}) ->
%      {Var, Val}
% end,
%end.
% NewName = fun({Lab, Value}) wab == first_name ->
%     lists:map(name_rh, Value);
%   ({Label, Content}) ->
%      {Label, Content}
%end,

%   lists:map(name_rh(), Value);


%[Var1, Var2, Var3, NewName].

%(paddy@caj)2> {resp_handler, Parse} = survey_tk:name_rh().
%{resp_handler,#Fun<survey_tk.8.36916771>}
%(paddy@caj)3> Parse("123 shamba wanjiku").
%"Wanjiku"