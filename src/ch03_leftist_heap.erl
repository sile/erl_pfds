%% @doc Figure 3.2. Leftist heaps.
-module(ch03_leftist_heap).

-behaviour(ch03_heap).

-export([empty/0, is_empty/1, insert/2, merge/2, find_min/1, delete_min/1]).
-export([from_list/1]). % exercise 3.3

-export_type([heap/0, elem/0]).

-opaque heap() :: empty | {tree, rank(), elem(), heap(), heap()}.
-type elem() :: ch03_heap:elem().
-type rank() :: non_neg_integer().

-spec empty() -> heap().
empty() -> empty.

-spec is_empty(heap()) -> boolean().
is_empty(empty) -> true;
is_empty(_)     -> false.

-spec merge(heap(), heap()) -> heap().
merge(H, empty) -> H;
merge(empty, H) -> H;
merge(H1 = {tree, _, X, A1, B1}, H2 = {tree, _, Y, A2, B2}) ->
    case X < Y of
        true  -> make_tree(X, A1, merge(B1, H2));
        false -> make_tree(Y, A2, merge(H1, B2))
    end.

-spec insert(elem(), heap()) -> heap().
insert(X, H) -> merge({tree, 1, X, empty, empty}, H).

-spec find_min(heap()) -> elem().
find_min({tree, _, X, _, _}) -> X;
find_min(H)                  -> error(badarg, [H]).

-spec delete_min(heap()) -> heap().
delete_min({tree, _, _, A, B}) -> merge(A, B);
delete_min(H)                  -> error(badarg, [H]).

-spec from_list([elem()]) -> heap().
from_list([])   -> empty();
from_list(List) ->
    MergeList =
        fun MergeList ([])            -> [];
            MergeList ([T])           -> [T];
            MergeList ([T1, T2 | Ts]) -> [merge(T1, T2) | MergeList(Ts)]
        end,
    Recur =
        fun Recur ([T]) -> T;
            Recur (Ts)  -> Recur(MergeList(Ts))
        end,
    Recur([{tree, 1, X, empty, empty} || X <- List]).

-spec rank(heap()) -> rank().
rank(empty)              -> 0;
rank({tree, R, _, _, _}) -> R.

-spec make_tree(elem(), heap(), heap()) -> heap().
make_tree(X, A, B) ->
    case rank(A) >= rank(B) of
        true  -> {tree, rank(B) + 1, X, A, B};
        false -> {tree, rank(A) + 1, X, B, A}
    end.
