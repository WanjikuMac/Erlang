-module(message).
-behavior(gen_statem).
-define(MESSAGE, message).

-export([init/1,callback_mode/0, has_message/3 ]).
-export([start/1, send_msg/0]).

%%client side routines
start(Sms) ->
	gen_statem:start({local,?MESSAGE}, ?MODULE, Sms, []).
send_msg() ->
	gen_statem:cast(?MESSAGE, has_message).
	


%server side routines
init(Sms)->
	has_msg(),
	Data = [Sms],
	{ok, has_message, Data}.

callback_mode() ->
	state_functions.

%%state routines
has_message(cast, has_message, Sms) ->
	io:format("~p~n", [Sms]),
	{next_state, waiting, Sms}.


%%helper functions
has_msg() ->
	io:format("Message Received~n", []).