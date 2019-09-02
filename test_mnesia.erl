-module(test_mnesia).
-export([do_this_once/0, add_shop_item/3]).

-record(shop, {item,quantity, cost}).
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
	
add_shop_item(Name, Quantity, Cost) ->
	Row = #shop{item = Name, quantity = Quantity, cost = Cost},
	F =fun() ->
				mnesia:write(Row)
		 end,
	mnesia:transaction(F).