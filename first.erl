-module(first).

-export([last/1, last_two/1, item_at/2, length/1, reverse/1, flatten/1, compress/1, pack/1]).

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

length([]) ->
  0;
length([_Head|Tail]) ->
  1 + first:length(Tail).
  
reverse(List) ->
  reverse(List, []).

reverse([Head|Tail], List) ->
  reverse(Tail, [Head|List]);
reverse([], List) ->
  List.

flatten(List) ->
  flatten(List, []).

flatten([Head|Tail], List) when is_list(Head) ->
  flatten(Head, flatten(Tail, List));
flatten([Head|Tail], List) ->
  [Head|flatten(Tail, List)];
flatten([], List) ->
  List.

compress(List) ->
  compress(List, empty).

compress([Head|Tail], Last) when Head == Last ->
  compress(Tail, Head);
compress([Head|Tail], _Last) ->
  [Head|compress(Tail, Head)];
compress([], _) ->
  [].

pack(List) ->
  pack(List, []).

pack([Head|Tail], []) ->
  pack(Tail, [Head]);
pack([Head|Tail], [Head|_Tail]) ->
  pack(Tail, [Head|[Head|_Tail]]);
pack([Head|Tail], [A|[]]) ->
  [A|pack(Tail, [Head])];
pack([Head|Tail], List) ->
  [List|pack(Tail, [Head])];
pack([], List) ->
  List.
