-module(world).
-export([start/0]).

start() ->
	spawn(person, init, ["Caroline"]),
	spawn(dog, init, []),
	spawn(rabbit, init, []).