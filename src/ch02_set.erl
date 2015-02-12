%% @doc Figure 2.7. Signature for sets
-module(ch02_set).

-export_type([set/0, elem/0]).

-type elem() :: term().
-type set() :: term().

-callback empty() -> set().
-callback insert(elem(), set()) -> set().
-callback member(elem(), set()) -> boolean().
