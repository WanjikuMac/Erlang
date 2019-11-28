-module(trade_fsm).
-behavior(gen_fsm).

%% Public API
-export([start/1]).

%%gen_fsm  callbacks
-export([start/1, start_link/1, trade/2, accept_trade/1,
	make_offer/2, retract_offer/2, ready/1, cancel/1]).
%% gen_fsm callbacks
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3,
	terminate/3, code_change/4,
% custom state names
	idle/2, idle/3, idle_wait/2, idle_wait/3, negotiate/2,
	negotiate/3, wait/2, ready/2, ready/3]).