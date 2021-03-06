-module(first).

-export([last/1, last_two/1, item_at/2, length/1, reverse/1, flatten/1, compress/1, pack/1, rle/1, rld/1, palindrome/1]).
-export([dup/1, dup/2, drop/2, split/2, slice/3]).

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

rle(List) ->
  rle(List, 0, empty).

rle([Head|Tail], 0, empty) ->
  rle(Tail, 1, Head);
rle([Head|Tail], Reps, Head) ->
  rle(Tail, Reps+1, Head);
rle([Head|Tail], Reps, Other) ->
  [{ Other, Reps }|rle(Tail, 1, Head)];
rle([], Reps, Head) ->
  [{ Head, Reps }].

rld([{ _Element, 0 }|Tail]) ->
  rld(Tail);
rld([{ Element, Times }|Tail]) ->
  [Element|rld([{ Element, Times - 1 }|Tail])];
rld([]) ->
  [].

palindrome(AList) ->
  Reverse = reverse(AList),
  case AList of
     Reverse ->
      true;
    _ ->
      false
  end.

dup([Head|Tail]) ->
  [Head|[Head|dup(Tail)]];
dup([]) ->
  [].

dup(List, Num) ->
  dup(List, Num, Num).

dup([], _, _) ->
  [];
dup([Head|Tail], 1, OrigCount) ->
  [Head|dup(Tail, OrigCount, OrigCount)];
dup([Head|Tail], Num, OrigCount) ->
  [Head|dup([Head|Tail], Num - 1, OrigCount)].

drop(List, Count) ->
  drop(List, Count, Count).

drop([], _, _) ->
  [];
drop([_Head|Tail], 1, OrigCount) ->
  drop(Tail, OrigCount, OrigCount);
drop([Head|Tail], Count, OrigCount) ->
  [Head|drop(Tail, Count - 1, OrigCount)].

split(List, 0) ->
  [[], List];
split([Head|Tail], Index) ->
  [First,Rest] = split(Tail, Index - 1),
  [[Head|First], Rest].

slice(_, 0, 0) ->
  [];
slice([], _, _) ->
  [];
slice([Head|Tail], 0, Length) ->
  [Head|slice(Tail, 0, Length - 1)];
slice([_Head|Tail], Index, Length) ->
  slice(Tail, Index - 1, Length).
