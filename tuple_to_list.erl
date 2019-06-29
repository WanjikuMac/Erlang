-module(tuple_to_list).

-export([my_tuple_to_list/2]).
%question 3 from page 86 of the Erlang Book

my_tuple_to_list({}, _) -> [];
my_tuple_to_list({Value, Value_2} ,[_ | _ ]) -> [H | T] || H <- Value, T<- my_tuple_to_list({Value_2}, [_ | _]).

%erlang:now/0 -- deprecated
%erlang:date/0
%erlang:time/0
%Write a function called my_time_func(F), which evaluates the fun F and times how long it takes.
%Write a function called my_date_string()that neatly formats the current date and time of day.