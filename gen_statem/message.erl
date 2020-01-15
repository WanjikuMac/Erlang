-module(message).
-behavior(gen_statem).
-define(MESSAGE, message).

-export([init/1,callback_mode/0, has_message/3, waiting/3 ]).
-export([start_link/1, send_msg/0]).

%%client side routines
start_link(Sms) ->
	gen_statem:start({local,?MESSAGE}, ?MODULE, Sms, []).
send_msg() ->
	gen_statem:cast(?MESSAGE, has_message).
	


%server side routines
init(Data)->
	has_msg(),
	{ok, has_message, Data}.

callback_mode() ->
	state_functions.

%%state routines
has_message(cast, has_message, Sms) ->
		[H | T]  = Sms,
			io:format("~p~n", [H]),
			{next_state, waiting, T, [{state_timeout, 5000, wait}]}.

waiting(state_timeout, wait, []) ->
	no_msg(),
	{keep_state, []};
waiting(state_timeout, wait, Data ) ->
	[Head | Tail] = Data,
	io:format("~p~n", [Head]),
	{next_state, has_message , Tail}.

%%helper functions
has_msg() ->
	io:format("Message List Received~n", []).
no_msg() ->
	io:format("List cleared~n", []).
%["welcome", "karibu", "join", "dias"]