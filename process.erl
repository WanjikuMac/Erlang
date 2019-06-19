-module(process).

- export([call/2, start/0,say_something/2, startp/0, pong/0,
          startm/0, ping/2]).

call(Arg1, Arg2) ->
  io:format("~p, ~p\n", [Arg1, Arg2]).
start() ->
  Pid = spawn(process, call, ["hello", "process"]),
  io:format("~p", [Pid]).

say_something(_What, 0) ->
   done;
say_something(What, Times) ->
  io:format("~p\n", [What]),
  say_something(What, Times -1).
startp() ->
  spawn(process, say_something, [hello, 3]),
  spawn(process, say_something, [goodbye, 3]).

ping(0, Pong_PID) ->
  Pong_PID ! finished,
  io:format("Ping is finished~n",[]);
ping(Times, Pong_PID) ->
  timer:sleep(100),
  Pong_PID ! {ping, self()},
    receive
      pong ->
        io:format("Ping received pong~n", [])
    end,
  ping(Times-1, Pong_PID).

pong() ->
  receive
    finished ->
      io:format("Pong is finished~n", []);
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong()
  end.
startm() ->
  Pong_PID = spawn(process, pong, []),
  %io:format("~p~n", [Pong_PID]),
  spawn(process, ping, [4, Pong_PID]).




