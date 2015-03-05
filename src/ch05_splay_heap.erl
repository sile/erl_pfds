%% @doc Figure 5.5. Implementation of heaps using splay trees.
-module(ch05_splay_heap).

-behaviour(ch03_heap).

-export([empty/0, is_empty/1, insert/2, merge/2, find_min/1, delete_min/1]).
-export_type([heap/0, elem/0]).

-opaque heap() :: empty | {tree, heap(), elem(), heap()}.
-type elem() :: ch03_heap:elem().

-spec empty() -> heap().
empty() -> empty.

-spec is_empty(heap()) -> boolean().
is_empty(empty) -> true;
is_empty(_)     -> false.

-spec insert(elem(), heap()) -> heap().
insert(X, T) ->
    {A, B} = partition(X, T),
    {tree, A, X, B}.

-spec merge(heap(), heap()) -> heap().
merge(empty, T)           -> T;
merge({tree, A, X, B}, T) ->
    {Ta, Tb} = partition(X, T),
    {tree, merge(Ta, A), X, merge(Tb, B)}.

-spec find_min(heap()) -> elem().
find_min({tree, empty, X, _}) -> X;
find_min({tree, A, _, _})     -> find_min(A);
find_min(T)                   -> error(badarg, [T]).

-spec delete_min(heap()) -> heap().
delete_min({tree, empty,               _, C}) -> C;
delete_min({tree, {tree, empty, _, B}, Y, C}) -> {tree, B, Y, C};
delete_min({tree, {tree,     A, X, B}, Y, C}) -> {tree, delete_min(A), X, {tree, B, Y, C}};
delete_min(T)                                 -> error(badarg, [T]).

-spec partition(elem(), heap()) -> {heap(), heap()}.
partition(_Pivot, empty)                                                 -> {empty, empty};
partition(Pivot, {_, A, X, B})              when X < Pivot,  B =:= empty -> {{tree, A, X, B}, empty};
partition(Pivot, {_, A, X, B})              when Pivot =< X, A =:= empty -> {empty, {tree, A, X, B}};
partition(Pivot, {_, A, X, {_, B1, Y, B2}}) when Y < Pivot ->
    {Small, Big} = partition(Pivot, B2),
    {{tree, {tree, A, X, B1}, Y, Small}, Big};
partition(Pivot, {_, A, X, {_, B1, Y, B2}}) when X < Pivot, Pivot =< Y->
    {Small, Big} = partition(Pivot, B1),
    {{tree, A, X, Small}, {tree, Big, Y, B2}};
partition(Pivot, {_, {_, A1, Y, A2}, X, B}) when Y < Pivot, Pivot =< X ->
    {Small, Big} = partition(Pivot, A2),
    {{tree, A1, Y, Small}, {tree, Big, X, B}};
partition(Pivot, {_, {_, A1, Y, A2}, X, B}) when Pivot =< Y ->
    {Small, Big} = partition(Pivot, A1),
    {Small, {tree, Big, Y, {tree, A2, X, B}}}.
