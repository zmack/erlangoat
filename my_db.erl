-module(my_db).

-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).
-export([init/0]).

start() ->
  register(my_db, spawn(my_db, init, [])).

init() ->
  loop([]).

loop(Data) ->
  receive 
    { stop, _, _ } ->
      stop();
    { request, From, Msg } ->
      { ok, NewData } = handle_msg(Msg, Data, From),
      loop(NewData)
  end.

respond(To, Message) ->
  io:format("Sending ~p to ~p~n", [Message, To]),
  To ! { ok, Message }.


handle_msg({ write, Key, Element }, Data, From) ->
  respond(From, { Key, Element }),
  NewData = [{Key, Element}| Data],
  { ok, NewData};

handle_msg({ read, Key }, Data, From) ->
  case lists:keysearch(Key, 1, Data) of
    { value, {Key, Value} } ->
      respond(From, Value);
    false ->
      ok
  end,
  { ok, Data };

handle_msg({ match, Element }, Data, From) ->
  Response = [X || { X, Val } <- Data, Val == Element],
  respond(From, Response),
  { ok, Data };

handle_msg({ delete, Key }, Data, From) ->
  case lists:keytake(Key, 1, Data) of
    { value, { Key, Value }, NewData } ->
      respond(From, { Key, Value }),
      { ok, NewData };
    false ->
      respond(From, {}),
      { ok, Data }
  end.

write(Key, Element) ->
  call(my_db, { write, Key, Element }).

read(Key) ->
  call(my_db, { read, Key }).

delete(Key) ->
  call(my_db, { delete, Key }).

match(Key) ->
  call(my_db, { match, Key }).

stop() ->
  my_db ! { stop }.

call(Name, Msg) ->
  Name ! { request, self(), Msg },
  standby().

standby() ->
  io:format("Standing by ~n"),
  receive
    { ok, Message } ->
      io:format("~p~n",[Message]);
    _ ->
      io:format("Bollocks")
  end.
