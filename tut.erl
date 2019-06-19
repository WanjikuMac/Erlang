-module(tut).

-export([ping/1, start/0, pong/0, startm/0, dog/0, rabbit/0]).

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