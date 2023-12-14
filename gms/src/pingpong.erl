-module(pingpong).
-export([start/0, ping/2, pong/0]).
ping(0, Pong_PID) ->
  Pong_PID ! finished;
ping(N, Pong_PID) ->
  Pong_PID ! {ping, self()},
  receive
    pong -> io:format("Pong!~n", [])
  end,
  ping(N - 1, Pong_PID).
pong() ->
  receive
    {ping, Ping_PID} ->
      io:format("Ping!~n", []),
      Ping_PID ! pong,
      pong();
    finished -> true
  end.
start() ->
  Pong_PID = spawn(?MODULE, pong, []), 
  spawn(?MODULE , ping, [3, Pong_PID]).