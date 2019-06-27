-module(tut).

-export([ping/1, start/0, pong/0, startm/0, dog/0, rabbit/0, keyword_rh/1]).

ping(0) ->
  pong ! finished,
    io:format("ping finished~n", []);
ping(Z) ->
  timer:sleep(100),
  pong ! {ping, self()},
  receive
    message ->
      io:format("ping received pong~n", [])
  end,
  ping(Z -1).

pong() ->
  receive
    finished ->
      io:format("pong finished~n");
    {ping, Ping_PID} ->
      io:format("pong received ping~n", []),
      Ping_PID ! message,
      pong()
  end.
start() ->
    register(pong, spawn(tut, pong, [])),
    spawn(tut, ping, [3]).


dog() ->
  receive {Rab_PID, message} ->
    io:format("woof woof rabbits ~n"),
    Rab_PID ! {dog ,message}
   end.
  %rab ! {self(), message},
  %receive
   % {rab, message} ->
      %io:format("woof woof rabbits~n")
  % end.
  %Message = "woof woof rabbits",
  %rab ! {self(), Message},
  %io:format("~p~n", [Message]).
rabbit() ->
  timer:sleep(100),
    dog ! {self(), message},
  receive
    {dog, message} ->
    io:format("panic go and hide~n")
  end.

startm() ->
    register(dog, spawn(tut, dog, [])),
      spawn(tut, rabbit, []).

keyword_rh(KWSpec) ->
  {resp_handler,
    fun (Input) ->
      MatchLens = lists:map(
        fun ({Variants, Out}) ->
          {lists:map(fun erlang:length/1,
            lists:filter(fun (Variant) ->
              match_keyword(Variant, Input)
                         end,
              Variants)),
            Out}
        end,
        KWSpec),
      Matches = lists:filter(fun (M) -> is_match(M) end, MatchLens),
      io:format("~s~n",[Matches]),
      Sorted = lists:sort(fun ({L1, _}, {L2, _}) -> lists:max(L1) > lists:max(L2) end, Matches),
      io:format("~s~n",[Sorted]),
      case Sorted of % Sometimes you want to accept "A" and "Africa" as different keywords
        [{_Lens, Out} | _] ->
          Out;
        [] ->
          {invalid, {keyword, [KWSpec], Input, not_an_option}}
      end
    end}.

match_keyword(KeywordRaw, InputRaw) ->
  Keyword = string:casefold(KeywordRaw),
  Input = string:casefold(string:trim(InputRaw)),
  string:find(Input, Keyword) =:= Input.

is_match({[], _}) -> false;
is_match(_) -> true.