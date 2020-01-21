%% A movie store that would let you check out one movie at a time.
-module(movie_store).
-behavior(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0, checkout/2,lookup/1]).
%%Api call routines
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

checkout(Customer, Movie) ->
	gen_server:call(?MODULE, {checkout, Customer, Movie}).

lookup(Customer) ->
	gen_server:call(?MODULE, {lookup, Customer}).

init([]) ->
	Tab = ets:new(?MODULE, []),
	io:format("~p~n", [Tab]),
	{ok, Tab}.

handle_call({checkout, Customer, Movie}, _From, Tab) ->
	Response = case ets:lookup(Tab, Customer) of
							 [] ->
								 ets:insert(Tab, {Customer, Movie}),
								 {ok, Movie};
							 [{Customer, Movie}] ->
								 {already_checked_out, Movie}
	           end,
	{reply, Response, Tab};
handle_call({lookup, Customer}, _From, Tab) ->
	Reply = case ets:lookup(Tab, Customer) of
						[{Customer, Movie}] ->
							Movie;
						[] ->
							none
	        end,
	{reply, Reply, Tab}.

handle_cast(_Request, State) -> {noreply, State}.
handle_info(_Request, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> {ok, State}.

