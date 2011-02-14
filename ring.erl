-module(ring).

-export([start/1, loop/1]).

start(0) ->
  ok;
start(Processes) ->
  Pid = spawn(ring, loop, [self()]),
  start(Processes - 1, Pid).

start(0, Pid) ->
  Pid;
start(Processes, Pid) ->
  start(Processes - 1, spawn(ring, loop, [Pid])).

loop(Pid) ->
  receive
    stop ->
      stop();
    Term ->
      Pid ! Term,
      io:format("~w~w~w~n",[Term, self(), Pid]),
      loop(Pid)
  end.

stop() ->
  io:format("Stopping ~w~n", [self()]).
