%% @doc Figure 3.6. Red black trees.
-module(ch03_read_black_set).

-behaviour(ch02_set).

-export([empty/0, insert/2, member/2]).
-export_type([set/0, elem/0]).

-opaque set() :: tree().
-type tree() :: empty | {color(), tree(), elem(), tree()}.
-type elem() :: ch02_set:elem().
-type color() :: r | b.

-spec empty() -> set().
empty() -> empty.

-spec member(elem(), set()) -> boolean().
member(_, empty)        -> false;
member(X, {_, L, Y, R}) ->
    if
        Y < X -> member(X, L);
        Y > X -> member(X, R);
        true  -> true
    end.

-spec insert(elem(), set()) -> set().
insert(X, S) ->
    Ins =
        fun Ins (empty)            -> {r, empty, X, empty};
            Ins ({Color, A, Y, B}) ->
                if
                    Y < X -> balance(Color, Ins(A), Y, B);
                    Y > X -> balance(Color, A, Y, Ins(B));
                    true  -> {Color, A, Y, B}
                end
        end,
    {_, A, Y, B} = Ins(S),  % guaranteed to be non-empty
    {b, A, Y, B}.

-spec balance(color(), tree(), elem(), tree()) -> tree().
balance(b, {r, {r, A, X, B}, Y, C}, Z, D) -> {r, {b, A, X, B}, Y, {b, C, Z, D}};
balance(b, {r, A, X, {r, B, Y, C}}, Z, D) -> {r, {b, A, X, B}, Y, {b, C, Z, D}};
balance(b, A, X, {r, {r, B, Y, C}, Z, D}) -> {r, {b, A, X, B}, Y, {b, C, Z, D}};
balance(b, A, X, {r, B, Y, {r, C, Z, D}}) -> {r, {b, A, X, B}, Y, {b, C, Z, D}};
balance(Color, A, X, B)                   -> {Color, A, X, B}.
