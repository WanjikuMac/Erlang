-module(test_mnesia).
-export([do_this_once/0, add_shop_item/3, remove_row/1, add_design/2, add_cost/2]).

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


%how to select specific data and view it from a table ?
%demo(select_some) ->
%	do(qlc:q([{X#shop.item, X#shop.quantity} || X <- mnesia:table(shop)])).
