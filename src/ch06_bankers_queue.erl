%% @doc Figure 6.1. Amortized queues using the banker's method
-module(ch06_bankers_queue).

-behaviour(ch05_queue).

-export([empty/0, is_empty/1, snoc/2, head/1, tail/1]).
-export_type([queue/0, elem/0]).

-define(S, ch04_stream).

-opaque queue() :: {len(), ?S:stream(), len(), ?S:stream()}.
-type elem() :: ch05_queue:elem().
-type len() :: non_neg_integer().

-spec empty() -> queue().
empty() -> {0, ?S:nil(), 0, ?S:nil()}.

-spec is_empty(queue()) -> boolean().
is_empty({0, _, _, _}) -> true;
is_empty({_, _, _, _}) -> false.

-spec snoc(queue(), elem()) -> queue().
snoc({LenF, F, LenR, R}, X) -> check({LenF, F, LenR + 1, ?S:cons(X, R)}).

-spec head(queue()) -> elem().
head({0, _, _, _} = Queue) -> error(badarg, [Queue]);
head({_, F, _, _})         -> ?S:head(F).

-spec tail(queue()) -> queue().
tail({0, _, _, _} = Queue) -> error(badarg, [Queue]);
tail({LenF, F, LenR, R})   -> check({LenF - 1, ?S:tail(F), LenR, R}).

-spec check(queue()) -> queue().
check(Queue = {LenF, F, LenR, R}) ->
    case LenR =< LenF of
        true  -> Queue;
        false -> {LenF + LenR, ?S:append(F, ?S:reverse(R)), 0, ?S:nil()}
    end.
