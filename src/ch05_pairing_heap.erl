%% @doc Figure 5.6. Pairing heaps.
-module(ch05_pairing_heap).

-behaviour(ch03_heap).

-export([empty/0, is_empty/1, insert/2, merge/2, find_min/1, delete_min/1]).
-export_type([heap/0, elem/0]).

-opaque heap() :: empty | {tree, elem(), [heap()]}.
-type elem() :: ch03_heap:elem().

-spec empty() -> heap().
empty() -> empty.

-spec is_empty(heap()) -> boolean().
is_empty(empty) -> true;
is_empty(_)     -> false.

-spec insert(elem(), heap()) -> heap().
insert(X, H) -> merge({tree, X, []}, H).

-spec merge(heap(), heap()) -> heap().
merge(empty, H)                                 -> H;
merge(H, empty)                                 -> H;
merge(H1 = {tree, X, Hs1}, H2 = {tree, Y, Hs2}) ->
    case X < Y of
        true  -> {tree, X, [H2 | Hs1]};
        false -> {tree, Y, [H1 | Hs2]}
    end.

-spec find_min(heap()) -> elem().
find_min({tree, X, _}) -> X;
find_min(Heap)         -> error(badarg, [Heap]).

-spec delete_min(heap()) -> heap().
delete_min({tree, _, Hs}) -> merge_pairs(Hs);
delete_min(Heap)          -> error(badarg, [Heap]).

-spec merge_pairs([heap()]) -> heap().
merge_pairs([])            -> empty;
merge_pairs([H])           -> H;
merge_pairs([H1, H2 | Hs]) -> merge(merge(H1, H2), merge_pairs(Hs)).
