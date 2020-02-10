-module(world).
-export([start/0]).

start() ->
	Person = spawn(person, init, ["Caroline"]),
	Dog = spawn(dog, init, []),
	Rabbit = spawn(rabbit, init, []),
	io:format("1st PID: ~p~n 2nd PID: ~p~n 3rd PID: ~p~n", [Person, Dog, Rabbit]),

	Rabbit ! {self(), "Poor Rabbits run for you life"}.