-module(band_supervisor).
-behavior(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Type) ->
	supervisor:start_link({local, ?MODULE},?MODULE, Type).
%% The band supervisor will allow its band members to make a few
%% mistakes before shutting down all operations, based on what
%% mood he's in. A lenient supervisor will tolerate more mistakes
%% than an angry supervisor, who'll tolerate more than a
%% complete jerk supervisor
init(lenient) ->
	init({one_for_one, 3, 60});
init(angry) ->
	init({rest_for_one, 2, 60});
init(jerk) ->
	init({one_for_all, 1, 60});

init({RestartStrategy, MaxRestart, MaxTime}) ->
	{ok, {{RestartStrategy, MaxRestart, MaxTime},
	[
		{
			singer, {musicians, start_link, [singer, good]},
			permanent, 1000, worker, [musicians]
		},
		{
			bass, {musicians, start_link, [bass, good]},
			temporary, 1000, worker, [musicians]
		},
		{
			drum, {musicians, start_link, [drum, bad]},
			transient, 1000, worker, [musicians]
		},
		{keytar,{musicians, start_link, [keytar, good]},
		transient, 1000, worker, [musicians]
		}
	]}}.