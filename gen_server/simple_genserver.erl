-module(simple_genserver).
-behavior(gen_server).

-define(CH3, simple_genserver).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	gen_server:start_link({local, ?CH3}, ?CH3, [], []).

init(_Args) ->
	{ok, channels()}.
