-module(ms).

-export([start/1, to_slave/2, slave/1, master_start/1]).

start(N) ->
  if
    N < 0 -> error;
    N >= 0 ->
      %Master = spawn(fun() -> master_start(N) end),
      %register(master, Master),
      register(master, spawn(ms, master_start, [N])),
      ok
  end.

to_slave(Message, N) ->
  master ! {Message,  N},
  ok.

master_start(N) ->
  process_flag(trap_exit, true),
  io:format("master spawning slaves ~n"),
  Slaves = spawn_slaves(N, dict:new()),
  io:format("master starting the main loop~n"),
  master_loop(Slaves).

slave(N) ->
  receive
    die ->
      exit({die, N});
    Message ->
      io:format("Slave ~p got message ~p~n", [N, Message]),
      slave(N)
  end.

%spawn link the slave function
  %Slave = spawn_link(slave).
  %Slave.

%spawn link the slave function to return a slave process
spawn_slave(N) ->
  Slave = spawn(fun() -> slave(N) end),
  link(Slave),
  Slave.

%links up all the started slave process together
spawn_slaves(N, Acc) ->
  if
    N == 0 -> Acc;
    N > 0 ->
      Slave = spawn_slave(N),
      spawn_slaves(N-1, dict:store(N, Slave, Acc))
  end.

master_loop(Slaves) ->
  receive
    {Message, N} ->
      case
        dict:find(N, Slaves) of
        error -> io:format("Slave ~p doesn't exist~n", [N]);
        {ok, Slave} -> Slave ! Message
      end,
      master_loop(Slaves);
      {'EXIT', _From, {die, N}} ->
        io:format("master restaring dead slave ~p~n", [N]),
        New_slave = spawn_slave(N),
        New_slaves = dict:store(N,New_slave, Slaves),
        master_loop(New_slaves)
  end.

