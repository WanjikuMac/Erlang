- module(record_example).
- export([add_player/6, convert/2, sum/1]).

-record(player,{playerName,cards,energy}).
-record(gamestate,{board,player,dices,game_round}).

add_player(Board, PlayerName, Cards, Energy, Dices, Game_round) ->
		#gamestate{
			board = Board,
			player = #player{playerName = PlayerName, cards = Cards, energy = Energy},
			dices = Dices,
			game_round = Game_round}.


%pattern matching example
convert({fahrenheit, Temp}, celsius) ->
	{celsius, 5 * (Temp - 32) / 9};
convert({celsius, Temp}, fahrenheit) ->
	{farenheit, 32 + Temp * 9 / 5};
convert({X, _}, Y) ->
	{cannot,convert,X,to,Y}.

% Recursion example
sum([H|T]) -> H + sum(T);
sum([]) -> 3.

%explanation that covers the record clause
% sum([1 | 2,3,4]) -> 1 + sum(T) - the result of this is below
% sum([2 | 3,4]) --> 2 + sum(T) -the result of this is below, all this explains recursion
%sum([3 | 4]) -> 3 + sum(T)
%sum(4) -> 4 + sum([])

%sum ([4 | 5,6]) -> 4 + sum(T)
%sum([5 | 6])  -> 5 + sum(T)
%sum([6]) -> 6 + sum(T)
%sum([]) -> 0
