%% @doc Exercise 3.4. Weight-biased leftist heaps
-module(ch03_weight_biased_leftist_heap).

%% -behaviour(ch03_heap).

-export([merge/2, topdown_merge/2]).
-export_type([heap/0, elem/0]).

-opaque heap() :: empty | {tree, rank(), elem(), heap(), heap()}.
-type elem() :: ch03_heap:elem().
-type rank() :: non_neg_integer().

-spec merge(heap(), heap()) -> heap().
merge(H, empty) -> H;
merge(empty, H) -> H;
merge(H1 = {tree, _, X, A1, B1}, H2 = {tree, _, Y, A2, B2}) ->
    case X < Y of
        true  -> make_tree(X, A1, merge(B1, H2));
        false -> make_tree(Y, A2, merge(H1, B2))
    end.

-spec topdown_merge(heap(), heap()) -> heap().
topdown_merge(H, empty) -> H;
topdown_merge(empty, H) -> H;
topdown_merge(H1 = {tree, _, X, A1, B1}, H2 = {tree, _, Y, A2, B2}) ->
    MakeTree =
        fun (Elem, T1, T2_a, T2_b) ->
                R1 = rank(T1),
                R2 = rank(T2_a) + rank(T2_b),
                case R1 >= R2 of
                    true  -> {tree, R1 + R2 + 1, Elem, T1, topdown_merge(T2_a, T2_b)};
                    false -> {tree, R1 + R2 + 1, Elem, topdown_merge(T2_a, T2_b), T1}
                end
        end,
    case X < Y of
        true  -> MakeTree(X, A1, B1, H2);
        false -> MakeTree(Y, A2, H1, B2)
    end.

-spec rank(heap()) -> rank().
rank(empty)              -> 0;
rank({tree, R, _, _, _}) -> R.

-spec make_tree(elem(), heap(), heap()) -> heap().
make_tree(X, A, B) ->
    case rank(A) >= rank(B) of
        true  -> {tree, rank(A) + rank(B) + 1, X, A, B};
        false -> {tree, rank(A) + rank(B) + 1, X, B, A}
    end.
