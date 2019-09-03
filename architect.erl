- module(architect).
-export([add_plans/0,get_plan/1]).

- record(design, {id, plan}).

add_plans() ->
	D1 = #design{id = {joe, 1},
							plan = {circle, 10}},
	D2 = #design{id =fred,
							plan = {rectangle, 10,5}},
	D3 = #design{id = {jane, {house,23}},
								plan = {house,
									[{floor,1,
										[{doors, 3},
											{windows,12},
											{rooms, 5}]},
										{floor, 2,
											[{doors,2},
												{rooms, 4},
												{windows, 15}]}]}},
	F =fun() ->
			mnesia:write(D1),
			mnesia:write(D2),
			mnesia:write(D3)
		 end,
	mnesia:transaction(F).

get_plan(PlanId) ->
	F =fun() -> mnesia:read({design, PlanId}) end,
	mnesia:transaction(F).