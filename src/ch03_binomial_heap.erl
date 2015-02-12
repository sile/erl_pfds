%% @doc Figure 3.4. Binomial heaps.
-module(ch03_binomial_heap).

-behaviour(ch03_heap).

-export([empty/0, is_empty/1, insert/2, merge/2, find_min/1, delete_min/1]).
-export_type([heap/0, elem/0]).

-opaque heap() :: [tree()].
-type tree() :: {node, rank(), elem(), [tree()]}.

-type elem() :: ch03_heap:elem().
-type rank() :: non_neg_integer().

-spec empty() -> heap().
empty() -> [].

-spec is_empty(heap()) -> boolean().
is_empty(Ts) -> Ts =:= [].

-spec insert(elem(), heap()) -> heap().
insert(X, Ts) -> ins_tree({node, 0, X, []}, Ts).

-spec merge(heap(), heap()) -> heap().
merge(Ts1, []) -> Ts1;
merge([], Ts2) -> Ts2;
merge(Ts1 = [T1 | Ts1_], Ts2 = [T2 | Ts2_]) ->
    case {rank(T1) < rank(T2), rank(T2) < rank(T1)} of
        {true, _} -> [T1 | merge(Ts1_, Ts2)];
        {_, true} -> [T2 | merge(Ts1, Ts2_)];
        _         -> ins_tree(link(T1, T2), merge(Ts1_, Ts2_))
    end.

-spec find_min(heap()) -> elem().
find_min(Ts) ->
    {T, _} = remove_min_tree(Ts),
    root(T).

-spec delete_min(heap()) -> heap().
delete_min(Ts) ->
    {{node, _, _, Ts1}, Ts2} = remove_min_tree(Ts),
    merge(lists:reverse(Ts1), Ts2).

-spec rank(tree()) -> rank().
rank({node, R, _, _}) -> R.

-spec root(tree()) -> elem().
root({node, _, X, _}) -> X.

-spec link(tree(), tree()) -> tree().
link(T1 = {node, R, X1, C1}, T2 = {node, R, X2, C2}) ->
    case X1 < X2 of
        true  -> {node, R + 1, X1, [T2 | C1]};
        false -> {node, R + 1, X2, [T1 | C2]}
    end.

-spec ins_tree(tree(), heap()) -> heap().
ins_tree(T, []) -> [T];
ins_tree(T, Ts = [T_ | Ts_]) ->
    case rank(T) < rank(T_) of
        true  -> [T | Ts];
        false -> ins_tree(link(T, T_), Ts_)
    end.

-spec remove_min_tree(heap()) -> {tree(), heap()}.
remove_min_tree([])       -> error(badarg, [[]]);
remove_min_tree([T])      -> {T, []};
remove_min_tree([T | Ts]) ->
    {T_, Ts_} = remove_min_tree(Ts),
    case root(T) < root(T_) of
        true  -> {T, Ts};
        false -> {T_, [T | Ts_]}
    end.
