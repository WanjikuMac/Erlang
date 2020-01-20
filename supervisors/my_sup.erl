-module(my_sup).
-behavior(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Number) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, [Number]).

init([Num]) ->
	SupFlags = #{strategy => one_for_one, intensity => 5, period => 30},
	ChildSpec = [#{id => test,
								start => {parallel, test, [Num]},
								restart => permanent,
								shutdown => 5000,
								type => worker,
								modules => [parallel]
								}],
		{ok, {SupFlags, ChildSpec}}.