-module(curling).

-export([start_link/2, add_points/3, next_round/1, join_feed/2, leave_feed/2, game_info/1]).

start_link(TeamA, TeamB)->
	{ok, Pid} = gen_event:start_link(),
	%% add ing the score board handler
	gen_event:add_sup_handler(Pid, curling_scoreboard, []),
	%% start the curling accumulator automatically
	gen_event:add_sup_handler(Pid, curling_accumulator, []),
	set_teams(Pid, TeamA, TeamB),
	{ok, Pid}.

set_teams(Pid, TeamA, TeamB) ->
	gen_event:notify(Pid, {set_teams, TeamA, TeamB}).
add_points(Pid, Team, N) ->
	gen_event:notify(Pid, {add_points, Team, N}).
next_round(Pid) ->
	gen_event:notify(Pid, next_round).

%% Subscribes the pid ToPid to the event feed.
%% The specific event handler for the newsfeed is
%% returned in case someone wants to leave

join_feed(Pid, ToPid) ->
	HandlerId={curling_feed, make_ref()},
	gen_event:add_sup_handler(Pid, HandlerId, [ToPid]),
	HandlerId.
leave_feed(Pid, HandlerId) ->
	gen_event:delete_handler(Pid, HandlerId, leave_feed).

%% Return current game status
game_info(Pid) ->
	gen_event:call(Pid, curling_accumulator, game_data).