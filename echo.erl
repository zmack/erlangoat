-module(echo).

-export([start/0, print/1, stop/0]).

start() ->
  register(echo, erlang:spawn(fun loop/0)).

print(Term) ->
  io:format("Received: ~w~n", [Term]).

stop() ->
  io:format("Stopping"),
  ok.

loop() ->
  receive
    stop ->
      stop();
    Term ->
      print(Term),
      loop()
    end.
