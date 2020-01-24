-module(my_sup).
-behavior(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	SupFlags = #{strategy => simple_one_for_one, intensity => 5, period => 5},
	ChildSpec = [#{id => test,
								start => {parallel, test_trial, []},
								restart => transient,
								shutdown => 5000,
								type => worker
								%modules => [parallel]
								}],
		{ok, {SupFlags, ChildSpec}}.