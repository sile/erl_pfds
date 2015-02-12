%% @doc Figure 3.1. Signature for heaps (priority queues)
-module(ch03_heap).

-export_type([heap/0, elem/0]).

-type heap() :: term().
-type elem() :: term().

-callback empty() -> heap().
-callback is_empty(heap()) -> boolean().
-callback insert(elem(), heap()) -> heap().
-callback merge(heap(), heap()) -> heap().
-callback find_min(heap()) -> elem().   % raises badarg if heap is empty
-callback delete_min(heap()) -> heap(). % raises badarg if heap is empty
