-module(simple_rest_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Route = [{'_', [{"/", rest_time_handler, []}]}],
	Dispatch = cowboy_router:compile(Route),
	
	ProtocolOpts = #{env =>  #{dispatch => Dispatch}},
	TransportOpts = [{port, 8080}],
	{ok, _} = cowboy:start_clear(my_http_listener, TransportOpts, ProtocolOpts),
	simple_rest_sup:start_link().

stop(_State) ->
	ok.
