%% @doc Figure 2.9. Implementation of binary search trees
-module(ch01_unbalanced_set).

-behaviour(ch01_set).

-export([empty/0, member/2, insert/2]).
-export_type([set/0]).

-opaque set() :: tree().
-type tree() :: empty | {tree, tree(), elem(), tree()}.
-type elem() :: ch01_set:elem().

-spec empty() -> set().
empty() -> empty.

-spec member(elem(), set()) -> boolean().
member(_, empty)           -> false;
member(X, {tree, L, Y, R}) ->
    if
        Y < X -> member(X, L);
        Y > X -> member(X, R);
        true  -> true
    end.

-spec insert(elem(), set()) -> set().
insert(X, empty)           -> {tree, empty, X, empty};
insert(X, {tree, L, Y, R}) ->
    if
        Y < X -> {tree, insert(X, L), Y, R};
        Y > X -> {tree, L, Y, insert(X, R)};
        true  -> {tree, L, Y, R}
    end.
