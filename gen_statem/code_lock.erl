-module(code_lock).
-behavior(gen_statem).
-define(NAME, code_lock).

-export([start_link/1, button/1, code_length/0]).
-export([init/1, callback_mode/0, terminate/3]).
-export([locked/3, open/3]).


%% api routines (client side)
start_link(Code) ->
	gen_statem:start_link({local, ?NAME}, ?MODULE, Code, []).
button(Button) ->
	%what is the need of having this in a tuple? OR is it preference
	gen_statem:cast(?NAME, {button, Button}).
%handles no state specific event
code_length() ->
	gen_statem:call(?NAME, code_length).

%callback routines (server side)
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
locked(cast, {button, Button},#{code := Code, length := Length, buttons := Buttons} = Data) ->
	io:format("~p~n", [Button]),
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
			%{next_state, NewStateName, NewData, Actions}
			{next_state, open, Data#{buttons := []}, [{state_timeout, 10000, lock}]};
		true ->
			{next_state, locked, Data#{buttons := NewButtons}}
	end;
locked(EventType, EventContent, Data) ->
	handle_common(EventType, EventContent, Data).

open(state_timeout, lock, Data) ->
	do_lock(),
	{next_state, locked, Data};
open(cast, {button, _Button}, Data) ->
	{next_state, open, Data};
open(EventType, EventContent, Data) ->
	handle_common(EventType, EventContent, Data).

handle_common({call, From}, code_length, #{code := Code} = Data) ->
	{keep_state, Data, [{reply, From, length(Code)}]}.

%%support routines
do_lock() ->
	io:format("Lock~n", []).
do_unlock() ->
	io:format("Unlock~n", []).

