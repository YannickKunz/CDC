-module(ping_pong_server).
-behaviour(gen_server).

-export([start_link/0, ping/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, hello/0]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

ping() ->
    gen_server:call(?MODULE, ping).

init([]) ->
    {ok, []}.

handle_call(ping, _From, State) ->
    {reply, pong, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

hello() -> "hello".
