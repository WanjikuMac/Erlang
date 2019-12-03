-module(bowling).

-export([allocate_team/1]).

allocate_team([]) -> io:format("randomization complete~n");
allocate_team(Names)->
	[H |T] = Names,
	Team_selector = rand:uniform(2),
	io:format("~p you are in team ~p ~n", [H, Team_selector]),
	allocate_team(T).
	
	