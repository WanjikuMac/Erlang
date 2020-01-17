-module(send).

-export([request/3, handle_eve/1, send_request/1, send_request_all/0]).

handle_eve({message, to, from}) ->
	{message, to, from},
	request(_WhappUrl, _WhappBody, _Auth).

request(WhappUrl, WhappBody, Auth) ->
	[Resp] = {ok, WhappUrl, WhappBody, Auth},
	io:format("~p", [Resp]).

send_request(ReqData) ->
	ParentPID = self(),
	spawn(fun() -> ParentPID ! handle_eve(ReqData) end).

send_request_all() ->
	[List] = fun request/3,
	lists:foreach(fun send_request/1, List).
