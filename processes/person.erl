-module(person).
-export([init/1, spawn_fun/0]).

init(Name) ->
	io:format("My name is ~p", [Name]).

spawn_fun() ->
	spawn(person, init, ["Caroline"]).