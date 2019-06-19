%%%-------------------------------------------------------------------
%% @doc names public API
%% @end
%%%-------------------------------------------------------------------

-module(names_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    names_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
