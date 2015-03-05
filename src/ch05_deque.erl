%% @doc Figure 5.3. Signature for double-ended queues.
-module(ch05_deque).

-export_type([queue/0, elem/0]).

-type queue() :: term().
-type elem() :: term().

-callback empty() -> queue().
-callback is_empty(queue()) -> boolean().

%% insert, inspect, and remove the front element
-callback cons(queue(), elem()) -> queue().
-callback head(queue()) -> elem().  % raises badarg if queue is empty
-callback tail(queue()) -> queue(). % raises badarg if queue is empty

%% insert, inspect, and remove the rear element
-callback snoc(queue(), elem()) -> queue().
-callback last(queue()) -> elem().  % raises badarg if queue is empty
-callback init(queue()) -> queue(). % raises badarg if queue is empty
