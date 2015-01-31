%% @doc Figure2.1. Signature for stacks
-module(ch01_stack).

-export_type([stack/0, elem/0]).

-type elem() :: term().
-type stack() :: term().

-callback empty() -> stack().
-callback is_empty(stack()) -> boolean().

-callback cons(elem(), stack()) -> stack().
-callback head(stack()) -> elem().  % raises badarg if stack is empty
-callback tail(stack()) -> stack(). % raises badarg if stack is empty
