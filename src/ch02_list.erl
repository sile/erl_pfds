%% @doc Figure2.2. Implementation of stacks using the built-in type of lists
-module(ch02_list).

-behaviour(ch02_stack).

-export([empty/0, is_empty/1, cons/2, head/1, tail/1]).
-export_type([stack/0]).

-opaque stack() :: [ch02_stack:elem()].

-spec empty() -> stack().
empty() -> [].

-spec is_empty(stack()) -> boolean().
is_empty([])    -> true;
is_empty([_|_]) -> false.

-spec cons(ch02_stack:elem(), stack()) -> stack().
cons(X, S) -> [X | S].

-spec head(stack()) -> ch02_stack:elem().
head(S) -> hd(S).

-spec tail(stack()) -> ch02_stack:elem().
tail(S) -> tl(S).
