-module(characters).
-behavior(gen_statem).
-import(string, [to_upper/1]).

%%qpi calls
-export([start_link/1, stop/0]).
-export([start_quote/0, quoted/0, not_quoted/0]).

%%callbacks
-export([init/1,callback_mode/0]).

%%state_callbacks
-export([start_state/3, waiting_state/2]).
	%in_quotes/0, not_in_quotes/0]).

-define(REGISTERED, characters).

start_link(StringValue) ->
	gen_statem:start_link({local, ?REGISTERED}, ?MODULE, StringValue,[]).

stop() ->
	gen_statem:stop(?REGISTERED).

start_quote() ->
	gen_statem:cast(?REGISTERED, string_value).
quoted() ->
	gen_statem:cast(?REGISTERED, quoted).
not_quoted() ->
	gen_statem:cast(?REGISTERED, not_quoted).

%%callback routines
init(StringValue) ->
	% New = convert_uppercase(value_upper, StringValue),
	%Timeout = session_duration(),
	%session_duration(waiting),
	{ok, waiting, StringValue}.

callback_mode() ->
	state_functions.

%% state callback routines
start_state(cast, string_value, StringValue) ->
	Resp = convert_uppercase(value_upper, StringValue),
%	Reply = {reply, From, {string_value}},
	{keep_state, Resp}.
waiting_state({call, From}, waiting) ->
	Reply = {reply, From},
	Timeout = session_duration(waiting),
	{keep_state, [Reply, {Timeout}]};
waiting_state(stop, state_timeout) ->
	{stop, string_value}.

%% business routines
convert_uppercase(value_upper, StringValue) ->
	Upper = string:to_upper(StringValue),
	io:format("~p~n", [Upper]).

session_duration(waiting) ->
	timer:hms(0,0,10).
	