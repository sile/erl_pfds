%% @doc Exercise 5.1. A batched deques
-module(ch05_batched_deque).

-behaviour(ch05_deque).

-export([empty/0, is_empty/1, cons/2, head/1, tail/1, snoc/2, last/1, init/1]).
-export_type([queue/0, elem/0]).

-opaque queue() :: {[elem()], [elem()]}.
-type elem() :: ch05_deque:elem().

-spec empty() -> queue().
empty() -> {[], []}.

-spec is_empty(queue()) -> boolean().
is_empty({[], _}) -> true;
is_empty({_,  _}) -> false.

-spec cons(queue(), elem()) -> queue().
cons({F, R}, X) -> checkr({[X | F], R}).

-spec head(queue()) -> elem().
head({[X | _], _}) -> X;
head(Queue)        -> error(badarg, [Queue]).

-spec tail(queue()) -> queue().
tail({[_ | F], R}) -> checkf({F, R});
tail(Queue)        -> error(badarg, [Queue]).

-spec snoc(queue(), elem()) -> queue().
snoc({F, R}, X) -> checkf({F, [X | R]}).

-spec last(queue()) -> elem().
last({_, [X | _]}) -> X;
last(Queue)        -> error(badarg, [Queue]).

-spec init(queue()) -> queue().
init({F, [_ | R]}) -> checkr({F, R});
init(Queue)        -> error(badarg, [Queue]).

-spec checkf(queue()) -> queue().
checkf({[], [_|_] = R}) ->
    {R1, R2} = lists:split(length(R) div 2, R),
    {lists:reverse(R2), R1};
checkf(Queue) -> Queue.

-spec checkr(queue()) -> queue().
checkr({[_|_] = F, []}) ->
    {F1, F2} = lists:split(length(F) div 2, F),
    {F1, lists:reverse(F2)};
checkr(Queue) -> Queue.
