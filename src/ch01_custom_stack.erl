%% @doc Figure 2.3. Implementation of stacks using a custom datatype
-module(ch01_custom_stack).

-behaviour(ch01_stack).

-export([empty/0, is_empty/1, cons/2, head/1, tail/1]).
-export_type([stack/0]).

-opaque stack() :: nil | {cons, ch01_stack:elem(), stack()}.

-spec empty() -> stack().
empty() -> nil.

-spec is_empty(stack()) -> boolean().
is_empty(nil) -> true;
is_empty(_)  -> false.

-spec cons(ch01_stack:elem(), stack()) -> stack().
cons(X, S) -> {cons, X, S}.

-spec head(stack()) -> ch01_stack:elem().
head({cons, X, _}) -> X;
head(X)            -> error(badarg, [X]).

-spec tail(stack()) -> ch01_stack:elem().
tail({cons, _, S}) -> S;
tail(X)            -> error(badarg, [X]).
