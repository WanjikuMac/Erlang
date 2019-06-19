-module(afile_server).

-export([start/1, loop/1]).

start(Dir) ->
  spawn(afile_server, loop, [Dir]).

loop(Dir) ->
  receive
    {Client, last_dir} ->
      Client ! {self(), file:list_dir(Dir)};
    {Client, {get_file, File}} ->
     Full = filename:join(Dir, File),
      Client !{self(), file:read_file(Full)};
    {Client, {put_file, File}} ->
      Full = filename:join(Dir, File),
      Client !{self(), file:consult(Full)}
  end,
  loop(Dir).
