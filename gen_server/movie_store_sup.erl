-module(movie_store_sup).
-behavior(supervisor).

-export([start_link/0, init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, []).

init([]) ->
	SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
	ChildSpec = #{id => 'movie',
								start => {movie_store, start_link, []},
								restart => temporary,
								shutdown => 3000,
								type => worker,
								module => [movie_store]},
	Children = [ChildSpec],
	{ok, {SupFlags,Children}}.