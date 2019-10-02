- module(db_sync_test).
- export([log_if_failed/1, update_var/2]).

log_if_failed(SyncFun) ->
	fun (Emp_no) ->
		Res = SyncFun(Emp_no),
		case Res of
			{ok, _} ->
				void;
			_ ->
				F = fun () -> mnesia:s_write({employee, element(1, Emp_no), Emp_no}) end,
				MRes = mnesia:transaction(F),
				case MRes of
					{atomic, _} ->
						void;
					_ ->
						io:format("Unexpected mnesia result when logging failed sync: ~p~n", [MRes]),
						error(sync_failed_error)
				end
		end,
		Res
	end.


update_var(From, To) ->
	fun ({Var, Val}) when Var =:= From ->
		{To, Val};
		({Keep, Val}) ->
			{Keep, Val}
	end.