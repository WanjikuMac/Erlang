-module(test_mnesia).
-export([do_this_once/0, add_shop_item/3, remove_row/1, add_design/2, add_cost/2, farmer/1, reset_tables/0, do/1, demo/1]).

-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).
-record(design, {name, cost}).

%routine to start the db and load the table sessions
%demo(select_shop) ->
%	do(qlc:q([X || X <- mnesia:table(shop)])).

%automate db creation
do_this_once() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
	mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]),
	mnesia:create_table(design,[{attributes, record_info(fields, design)}]),
	mnesia:stop().

% add a row to the design table
add_design(Name, Cost) ->
	Row =#design{name =Name, cost = Cost},
	F = fun() ->
		mnesia:write(Row)
			end,
	mnesia:transaction(F).

%add a row to the cost table
add_cost(Name, Price) ->
	Row = #cost{name = Name, price = Price},
	F = fun() ->
		mnesia:write(Row)
			end,
	mnesia:transaction(F).

% add a column to the shop table
add_shop_item(Name, Quantity, Cost) ->
	Row = #shop{item = Name, quantity = Quantity, cost = Cost},
	F =fun() ->
				mnesia:write(Row)
		 end,
	mnesia:transaction(F).
%hoe to remove a row (Item is the primary key of the table)
remove_row(Item)->
	Oid ={shop, Item},
	F = fun() ->
			mnesia:delete(Oid)
			end,
	mnesia:transaction(F).


%Aborting a transaction
farmer(Nwant) ->
	%% Nwant = The number of oranges the farmer wants
	F = fun() ->
		%% Find the number of apples the farmer has and should give to get oranges
		
			[Apple] = mnesia:read({shop, apple}),
			Napples = Apple#shop.quantity,
			Apple1 = Apple#shop{quantity = Napples + 2*Nwant},
		%% update the database
		mnesia:write(Apple1),
		
		%%Find rhe number of oranges
			[Orange] = mnesia:read({shop, orange}),
			NOranges = Orange#shop.quantity,
		if NOranges >= Nwant ->
			N1 =NOranges- Nwant,
				Orange1 = Orange#shop{quantity = N1},
			%% Update the database
			mnesia:write(Orange1);
			true ->
				%%oops not enough oranges
			mnesia:abort(Orange)
		end
	end,
mnesia:transaction(F).
	
% Loading test data
example_tables() ->
	[%% The shop table
		{shop, apple, 20, 2.3},
		{shop, orange, 100,3.8},
		{shop, pear, 200, 3.6},
		{shop, banana, 420, 4.5},
		{shop, potato, 456, 1.2},
		% The cost table
		{cost, apple, 1.5},
		{cost, orange, 2.4},
		{cost, pear, 2.2},
		{cost, banana, 1.5},
		{cost, potato, 0.6}
    ].

%This function writes data from the examples to mnesia
reset_tables() ->
	mnesia:clear_table(shop),
	mnesia:clear_table(cost),
	F = fun() ->
		lists:foreach(fun mnesia:write/1, example_tables())
			end,
	mnesia:transaction(F).

% The do function
do(Q) ->
	F = fun() -> qlc:e(Q) end,
	{atomic, Val} = mnesia:transaction(F),
	Val.

%how to select specific data and view it from a table ?
demo(select_shop) ->
do(qlc:q([{X#shop.item, X#shop.quantity} || X <- mnesia:table(shop)])).
