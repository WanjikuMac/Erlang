-module(simple_genserver).
-behavior(gen_server).

-define(CH3, simple_genserver).

-export([start_link/0]).
-export([add/1]).
-export([init/1, handle_call/3, handle_cast/2]).

%% api routines
start_link() ->
	gen_server:start_link({local, ?CH3}, ?CH3, [], []).

add(Name) ->
	gen_server:call(?CH3, {add, Name}).


init(_Args) ->
	io:format("started~n"),
	State = dict:new(),
	{ok, State}.

handle_call({add, Name}, _From, State) ->
	Reply = dict:store(add, Name, State),
	io:format("~p",[State]),
		{reply, Reply, State}.

handle_cast(_Request, _State) ->
	{noreply}.
