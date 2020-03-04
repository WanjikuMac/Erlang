-module(request).
-export([make_request/4, start/0, post/3, make_request/0]).

start() ->
ssl:start().


post(URL, ContentType, Body) ->make_request(post, {URL, [], ContentType, Body}, [], []).

make_request(Method, Request, [], []) ->
	%The request contains
	%      {url(), headers(), content-type(), body()}
	
%	Body = {'username': "paddy_40130", 'from': "+254711082951", "to": "+254718959202"},
	%httpc:request(post, {"https://api.africastalking.com/test/voice","application/x-www-form-urlencoded", "{'username' : 'paddy_40130'}"}, [], []).
	httpc:request(Method, Request, [], []).

make_request() ->
	httpc:request(post, {"https://api.africastalking.com/test/voice", [], "application/x-www-form-urlencoded", some_body}, [], []).

%Body = {response=Response}