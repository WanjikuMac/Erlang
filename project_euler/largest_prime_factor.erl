-module(largest_prime_factor).
-export([main/0]).

main() ->
    io:format("Answer ~p ~n",[pr(1,600851475143,1)]).

pr(1, N, 1) when N rem 2 =:= 0                          -> pr(1, N, 2);
pr(1, N, A) when N rem 3 =:= 0, A < 3                   -> pr(1, N, A*3);
pr(_, N, A) when A > N                                  -> 0;
pr(K, N, A) when (N rem (6*K+1)) =:= 0, (6*K+1)*A =:= N -> 6*K+1;
pr(K, N, A) when (N rem (6*K-1)) =:= 0, (6*K-1)*A =:= N -> 6*K-1;   
pr(K, N, A)                                             ->
    case {N rem (6*K-1), N rem (6*K+1)} of
        {0, 0} -> pr(K+1, N, A*(6*K+1)*(6*K-1));
        {_, 0} -> pr(K+1, N, A*(6*K+1));
        {0, _} -> pr(K+1, N, A*(6*K-1));
        _      -> pr(K+1, N, A)
    end.