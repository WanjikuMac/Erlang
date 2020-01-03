-module(session_sm).
-behavior(gen_statem).

%% api
-export([start_link/1]).
-export([stop/0]).
-export([bump/0, request/1, request/2]).

%% callback
-export([init/1, callback_mode/0, code_change/4, terminate/3]).

%% state-callback
-export([waiting/3, alive/3]).

-define(REGISTERED, session_sm).
-define(CHARS, "ABCDEFGHIJKLMNPQRSTUVWXYZ"
								"abcdefghijklmnopqrstuvwxyz123456789").

-record(session, {email, key}).

%api routines
start_link(<<Email/bitstring>>) ->
	gen_statem:start_link({local, ?REGISTERED}, ?MODULE, Email, []).

stop() ->
	gen_statem:stop(?REGISTERED).
bump()  ->
	gen_statem:cast(?REGISTERED, bump).
request(key) ->
	gen_statem:call(?REGISTERED, key);
request(departure) ->
	gen_statem:cast(?REGISTERED, departure).
request(entry, Key) ->
	gen_statem:call(?REGISTERED, {entry, Key}).

%callback routines
init(<<Email/bitstring>>) ->
	ok = handle(start_statem),
	{ok, Ld} = handle(new_session, Email),
	Timeout = session_duration(waiting),
	{ok, waiting, Ld, [{state_timeout, Timeout, hard_stop}]}.

callback_mode() ->
	state_functions.
code_change(_Vsn, State, Ld, _Extra) ->
	{ok, State, Ld}.
terminate(_Reason, State, #session{}=Ld) ->
	ok = handle_stop_session(State, Ld),
	handle(stop_statem).

% state-callback routines
alive(cast, bump, #session{}=Ld) ->
	ok = handle(bump_session, Ld),
	Timeout = session_duration(alive),
	{keep_state, Ld, [{state_timeout, Timeout, hard_stop}]};
alive(cast, departure, #session{}=Ld) ->
	{stop, normal, Ld};
alive(state_timeout, hard_stop, #session{}=Ld) ->
	{stop, alive_timed_out,Ld};
alive(EventType, EventContent, #session{}=Ld) ->
	handle_event({EventType, EventContent, Ld}).

waiting({call, From}, key, #session{key=Key}=Ld) ->
	Reply = {reply, From, {key, Key}},
	{keep_state, Ld, [Reply]};
waiting({call, From}, {entry, Key}, #session{}=Ld) ->
	{ok, Ld1} = handle(start_session, {Key, Ld}),
	Reply = {reply, From, ok},
	Timeout = session_duration(alive),
	{next_state, alive, Ld1, [Reply, {state_timeout, Timeout, hard_stop}]};
waiting(state_timeout, hard_stop, #session{}=Ld) ->
	{stop, waiting_timed_out, Ld};
waiting(EventType, EventContent, #session{}=Ld) ->
	handle_event({EventType, EventContent, Ld}).

%
% business routines
%
handle_stop_session(waiting, _) -> ok;
handle_stop_session(_, #session{}=Ld) ->
	handle(stop_session, Ld),
	ok.
handle(start_statem) ->
	io:format(user, "*** Start statem~n", []),
	ok;
handle(stop_statem) ->
	io:format(user, "*** Stop statem~n", []),
	ok.
handle(bump_session, #session{key=Key}) ->
	io:format(user, "*** Bump session: ~p~n", [Key]),
	ok;
handle(new_session, <<Email/bitstring>>) ->
	{ok, Key} = handle_key(),
	Ld = #session{email=Email, key=Key},
	io:format(user, "*** Create session: ~p :~p ~n", [Email, Key]),
	{ok, Ld};
handle(start_session, {Key, #session{key=Key}=Ld}) ->
	io:format(user, "*** Start session: ~p~n", [Key]),
	{ok, Ld};
handle(stop_session, #session{key=Key}) ->
	io:format(user, "*** Stop session: ~p~n", [Key]),
	{ok, #session{}}.

handle_key() -> handle_key(8).

handle_key(N) ->
	dirty_seed(),
	Key = binary_key(N),
	{ok, Key}.
handle_event({_,_, Ld}) ->
	{keep_state, Ld}.

%support routines
binary_key(N) ->
	Cs =erlang:list_to_tuple(?CHARS),
	CsLen = erlang:tuple_size((Cs)),
	Key = [pick(CsLen, Cs) || _  <- lists:seq(1,N)],
	erlang:list_to_binary(Key).

dirty_seed() ->
	<<X:32, Y:32, Z:32>> = crypto:strong_rand_bytes(12),
	rand:seed(exs1024s, {X,Y,Z}).

pick(K, Ts) ->
	C =rand:uniform(K),
	erlang:element(C, Ts).

session_duration(alive) ->
	timer:hms(1,10,0);
session_duration(waiting) ->
	timer:hms(0,10,0).