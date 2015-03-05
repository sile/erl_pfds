%% @doc Figure 5.2. A common implementation of purely functional queues
-module(ch05_batched_queue).

-behaviour(ch05_queue).

-export([empty/0, is_empty/1, snoc/2, head/1, tail/1]).
-export_type([queue/0, elem/0]).

-opaque queue() :: {[elem()], [elem()]}.
-type elem() :: ch05_queue:elem().

-spec empty() -> queue().
empty() -> {[], []}.

-spec is_empty(queue()) -> boolean().
is_empty({[], _}) -> true;
is_empty({_,  _}) -> false.

-spec snoc(queue(), elem()) -> queue().
snoc({F, R}, X) -> checkf({F, [X | R]}).

-spec head(queue()) -> elem().
head({[X | _], _}) -> X;
head(Queue)        -> error(badarg, [Queue]).

-spec tail(queue()) -> queue().
tail({[_ | F], R}) -> checkf({F, R});
tail(Queue)        -> error(badarg, [Queue]).

-spec checkf(queue()) -> queue().
checkf({[], R}) -> {lists:reverse(R), []};
checkf(Queue)   -> Queue.
