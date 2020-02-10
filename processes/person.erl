-module(person).
-export([person/1]).

person(Name) ->
	io:format("My name is ~p", Name).