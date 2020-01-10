-module(code_lock).
-behavior(gen_statem).
-define(NAME, code_lock).

-export([start_link/1, button/1]).
-export([init/1, callback_mode/0, terminate/3]).
-export([locked/3, open/3]).


%% api routines
start_link(Code) ->
	gen_statem:start_link({local, ?NAME}, ?MODULE, Code, []).
button(Button) ->
	gen_statem:cast(?NAME, {button, Button}).


%callback routines
init(Code) ->
	do_lock(),
	Data = #{code => Code, length => length(Code), buttons => []},
	{ok, locked, Data}.

callback_mode() ->
	state_functions.

terminate(_Reason, State, _Data) ->
	State =/= locked andalso do_lock(),
	ok.

%%state routines
locked(cast, {button, Button},#{code :=Code, length := Length, buttons := Buttons} = Data) ->
	NewButtons =
		if
			length(Buttons) < Length ->
				Buttons;
			true ->
				tl(Buttons)
		end ++ [Button],
	if
		NewButtons =:= Code ->
			do_unlock(),
			{next_state, open, Data#{buttons := []},
			[{state_timeout, 10000, lock}]};
		true ->
			{next_state, locked, Data#{buttons := NewButtons}}
	end.

open(state_timeout, lock, Data) ->
	do_lock(),
	{next_state, locked, Data};
open(cast, {button, _Button}, Data) ->
	{next_state, oprn, Data}.


%%support routines
do_lock() ->
	io:format("Lock~n", []).
do_unlock() ->
	io:format("Unlock~n", []).

