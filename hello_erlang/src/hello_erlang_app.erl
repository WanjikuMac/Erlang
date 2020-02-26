-module(hello_erlang_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	% Routes take different structures im
	% Routes = [Host1, Host2, ... HostN] the host contains matching rules
	% for the host along with optional constrains and a list of routes for the path component
	% In our case we are using
	%           * Host = {HostMatch, PathList} => [{'_', Pathlist}].
	% and for the path list
	%           * Pathlist = [{PathMatch, Handler, InitialState}] => [{"/", hello_handler, []}].
	Routes = [{ '_', [{"/", hello_handler, []}] }],
	Dispatch = cowboy_router:compile(Routes),
	ProtocolOpts = #{env => #{dispatch => Dispatch}},
	{ok, _ } = cowboy:start_clear(my_http_listener, [{port,8080}], ProtocolOpts),
	hello_erlang_sup:start_link().

stop(_State) ->
	ok.
