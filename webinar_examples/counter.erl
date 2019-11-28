-module(counter).
-behavior(gen_event).

-export([init/1,handle_event/2, handle_call/2, code_change/3, handle_info/2, terminate/2]).

init(_Args) ->
	io:put_chars("** 0: initialize to zero~n"),
	{ok, 0}.

handle_event(Event, Count) ->
	io:format("** +1: got event ~p~n", [Event]),
	{ok, Count + 1}.
handle_call(Request, Count) ->
	io:format("** got request ~p~n", [Request]),
	{ok, Count, Count}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Args, _State) -> ok.