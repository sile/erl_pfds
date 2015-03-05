%% @doc Figure 5.1. Signature for queues
-module(ch05_queue).

-export_type([queue/0, elem/0]).

-type queue() :: term().
-type elem() :: term().

-callback empty() -> queue().
-callback is_empty(queue()) -> boolean().

-callback snoc(queue(), elem()) -> queue().
-callback head(queue()) -> elem().  % raises badarg if queue is empty
-callback tail(queue()) -> queue(). % raises badarg if queue is empty
