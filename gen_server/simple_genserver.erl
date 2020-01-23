-module(simple_genserver).
-behavior(gen_server).

-define(CH3, simple_genserver).

-export([start_link/0]).
-export([add/2, get/1]).
-export([init/1, handle_call/3, handle_cast/2]).

%% api routines
start_link() ->
	gen_server:start_link({local, ?CH3}, ?CH3, [], []).

add(Name, Location) ->
	gen_server:call(?CH3, {add, Name, Location}).
get(Name) ->
	gen_server:call(?CH3, {lookup, Name}).


init(_Args) ->
	Tab = ets:new(?CH3, []),
	{ok, Tab}.

handle_call({add, Name, Location}, _From, Tab) ->
		Reply = ets:insert(Tab, {Name, Location}),
		{reply, Reply, Tab};

handle_call({lookup, Name}, _From, Tab) ->
	Reply = ets:lookup(Tab, Name),
	%io:format("~p", [Reply]),
	{reply, Reply, Tab}.

handle_cast(_Request, _State) ->
	{noreply}.
