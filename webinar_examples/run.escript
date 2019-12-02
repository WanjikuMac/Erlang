#! /usr/bin/env escript

main(_Args) ->
    {ok, _Pid}=gen_event:start_link({local, event_dispatcher}),
    gen_event:add_handler(event_dispatcher, counter, []),
    Event ={ any erlang term},
    ok = gen_event:notify(event_dispatcher, Event),
    Request = {any erlang term},
    Count = gen_event:call(event_dispatcher, counter, Request),
    io:format("Event count = ~w~n", [Count]).

