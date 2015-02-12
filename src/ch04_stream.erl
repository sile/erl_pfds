%% @doc Figure 4.1. A small streams package.
-module(ch04_stream).

-export([nil/0, cons/2, force/1, append/2, take/2, drop/2, reverse/1]).
-export_type([stream/0, stream_cell/0, elem/0]).

-type stream_cell() :: nil | {elem(), stream()}.
-type stream() :: {lazy, fun (() -> stream_cell())} | stream_cell().
-type elem() :: term().

-define(LAZY(Exp), {lazy, fun () -> force(Exp) end}).

-spec nil() -> stream().
nil() -> {lazy, fun () -> nil end}.

-spec cons(elem(), stream()) -> stream().
cons(X, Xs) ->
    %% XXX: X is evaluated immediately
    {lazy, fun () -> {X, Xs} end}.

-spec append(stream(), stream()) -> stream().
append(Xs0, Ys) ->
    ?LAZY(
       case force(Xs0) of
           nil       -> Ys;
           {X1, Xs1} -> cons(X1, append(Xs1, Ys))
       end).

-spec take(non_neg_integer(), stream()) -> stream().
take(N, Xs0) ->
    ?LAZY(
       case N of
           0 -> nil();
           _ ->
               case force(Xs0) of
                   nil       -> nil();
                   {X1, Xs1} -> cons(X1, take(N - 1, Xs1))
               end
       end).

-spec drop(non_neg_integer(), stream()) -> stream().
drop(N0, Xs0) ->
    ?LAZY(
       (fun Drop(0, Ys)  -> Ys;
           Drop(N, Ys0) ->
               case force(Ys0) of
                   nil      -> nil();
                   {_, Ys1} -> Drop(N - 1, Ys1)
               end
        end)(N0, Xs0)).

-spec reverse(stream()) -> stream().
reverse(Xs) ->
    ?LAZY(
       (fun Rev (nil, R)     -> R;
            Rev ({Y, Ys}, R) -> Rev(force(Ys), cons(Y, R))
        end)(force(Xs), nil())).

-spec force(stream()) -> stream_cell().
force({lazy, S}) ->
    _ = case get({memo, S}) of
            undefined -> put({memo, S}, {ok, S()});
            {ok, _}   -> ok
        end,
    {ok, Val} = get({memo, S}),
    Val;
force(Forced) -> Forced.
