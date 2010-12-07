-module(first).

-export([last/1, last_two/1, item_at/2]).

last([]) ->
  empty;
last([Head|[]]) ->
  Head;
last([_Head|Tail]) ->
  io:format("~p~n", [Tail]),
  last(Tail).

last_two([]) ->
  empty;
last_two([Head|[]]) ->
  [Head];
last_two([Head,Tail]) ->
  [Head, Tail];
last_two([_Head|Tail]) ->
  last_two(Tail).
  

item_at([], Index) when Index < 0 -> 
  empty;
item_at([], 0) ->
  empty;
item_at([Head|_Tail], 0) ->
  Head;
item_at([_Head|Tail], Index) ->
  item_at(Tail, Index - 1).
