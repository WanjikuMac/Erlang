-module(test_try).
-export([generate_exception/1]).

generate_exception(1) -> a;
fun (Raw) ->
TruncateAfter = [$!, $", $#, $$, $%, $&, $(, $), $*, $+, $-, $/, $:, $;, $<, $=, $>, $?, $@, $], $., $\\],
%truncate any values after the symbols above
TruncatedValue = lists:takewhile(fun(X) -> not lists:member(X, TruncateAfter) end, Raw),
Tokens = string:tokens(string:trim(TruncatedValue), " "),
%Return the string without any member of the list below
ToFilter = lists:map(fun string:casefold/1, ["I", "am", "Mimi", "jina", "Langu" "ni", "naitwa","FARM","shamba", " Mr.",
"my", "name", "is", "jiunge", "join", "welcome", "yes", "40130"]),
FilteredList= lists:filter(fun(X) -> not lists:member(string:casefold(X), ToFilter) end, Tokens),
%Drop any integers present
DropInteger = lists:filter(fun (X) -> not lists:all(fun (A) -> A >= $0 andalso A =< $9 end, X)end, FilteredList),
case DropInteger of
%Return rafiki if the name contains one character
[[_W]| _Rest] -> "Rafiki";
%Return name if the it contains more than one character
[H| _T] -> [Head|Tail] = lists:flatten(string:replace(H, "0", "o")),
[string:to_upper(Head) | string:to_lower(Tail)];
[] -> "Rafiki"
end
end}.