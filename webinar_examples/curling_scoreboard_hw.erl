-module(curling_scoreboard_hw).
-export([set_teams/2, next_round/0, add_point/1, reset_board/0]).

%% This is a 'dumb' module that's only there to replace what a real hardware
%% controller would likely do. The real hardware controller would likely hold
%% some state and make sure everything works right, but this one doesn't mind.

%% Shows the teams on the scoreboard.
set_teams(TeamA,TeamB) ->
	io:format("Scoreboard: Team ~s vs. Team ~s~n", [TeamA,TeamB]).
next_round() ->
	io:format("Scoreboard: round over ~n").
add_point(Team) ->
	io:format("Scoreboard increased score of Team ~s by 1 ~n", [Team]).
reset_board()->
	io:format("All teams are undefined and all scores are 0~n").

