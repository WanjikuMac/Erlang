- record(todo, {status=reminder, name=joe, text}).

clear_status(#todo{status = S, name = T} = R) ->
  R#todo{status = finished}.

%To match a record of a particular type, we might write the function definition.
% do_something(X) when is_record(X, todo) ->


