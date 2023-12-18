-module(myP).
-export([start/2, create_processes/2, group_loop/3, process/0,
list_members/1,send_message/2, send_message_to_group/3, 
send_message_to_group/4, add_process/1, delete_process/2, delete_group/1]).

start(GroupName, NumberOfProcesses) ->
    Pids = create_processes(NumberOfProcesses, []),
    register(GroupName, spawn(?MODULE, group_loop, [GroupName, Pids, []])),
    {ok, GroupName}.

add_process(GroupName) ->
    GroupPid = whereis(GroupName),
    NewProcessPid = spawn(?MODULE, process, []),
    GroupPid ! {add_process, NewProcessPid}.

delete_process(GroupName, ProcessPid) ->
    GroupPid = whereis(GroupName),
    GroupPid ! {delete_process, ProcessPid}.

create_processes(0, Acc) ->
    lists:reverse(Acc);
create_processes(N, Acc) ->
    Pid = spawn(?MODULE, process, []),
    create_processes(N - 1, [Pid | Acc]).

group_loop(GroupName, Pids, ReceivedMessages) ->
    io:format("Initializing group ~p with members ~p~n", [GroupName, Pids]),
    receive
        {join, MemberPid} ->
            io:format("Member ~p joined group~n", [MemberPid]),
            group_loop(GroupName, [MemberPid | Pids], ReceivedMessages);
        {list_members, Requester} ->
            Requester ! {list_members_response, Pids},
            group_loop(GroupName, Pids, ReceivedMessages);
        {send_message, {SeqNum, Message}, Sender} ->
            if 
                Sender =/= self() ->
                    case lists:member(SeqNum, ReceivedMessages) of
                        false ->
                            lists:foreach(fun(Member) -> Member ! {message, {SeqNum, Message}, Sender} end, Pids),
                            group_loop(GroupName, Pids, [SeqNum | ReceivedMessages]);
                        true ->
                            group_loop(GroupName, Pids, ReceivedMessages)
                    end
            end;
        {send_message_to_group, TargetGroupPid, {SeqNum, Message}, Sender} ->
            if 
                Sender =/= self() ->
                    case lists:member(SeqNum, ReceivedMessages) of
                        false ->
                            TargetGroupPid ! {send_message, {SeqNum, Message}, Sender},
                            group_loop(GroupName, Pids, [SeqNum | ReceivedMessages]);
                        true ->
                            group_loop(GroupName, Pids, ReceivedMessages)
                    end
            end;
        {add_process, NewProcessPid} ->
            group_loop(GroupName, [NewProcessPid | Pids], ReceivedMessages);
        {delete_process, ProcessPid} ->
            group_loop(GroupName, lists:delete(ProcessPid, Pids), ReceivedMessages);
        stop ->
            lists:foreach(fun(Member) -> Member ! stop end, Pids)
    end.

process() ->
    receive
        Message when Message =/= stop ->
            io:format("Process ~p received message ~p~n", [self(), Message]),
            process();
        stop ->
            exit(normal)
    end,
    process().

list_members(GroupName) ->
    register(list_members_requester, self()),
    GroupPid = whereis(GroupName),
    GroupPid ! {list_members, list_members_requester},
    receive
        {list_members_response, Members} ->
            unregister(list_members_requester),
            {ok, Members}
    end.

send_message(GroupName, Message) ->
    GroupPid = whereis(GroupName),
    %% Generate a unique sequence number for each message
    SeqNum = make_ref(),
    GroupPid ! {send_message, {SeqNum, Message}, self()}.

send_message_to_group(SourceGroupName, TargetGroupName, Message) ->
    SourceGroupPid = whereis(SourceGroupName),
    TargetGroupPid = whereis(TargetGroupName),
    %% Generate a unique sequence number for each message
    SeqNum = make_ref(),
    SourceGroupPid ! {send_message_to_group, TargetGroupPid, {SeqNum, Message}, self()}.

send_message_to_group(SourceGroupName, TargetNodeName, TargetGroupName, Message) ->
    SourceGroupPid = whereis(SourceGroupName),
    TargetGroupPid = rpc:call(TargetNodeName, erlang, whereis, [TargetGroupName]),
    %% Generate a unique sequence number for each message
    SeqNum = make_ref(),
    SourceGroupPid ! {send_message_to_group, TargetGroupPid, {SeqNum, Message}, self()}.

delete_group(GroupName) ->
    GroupPid = whereis(GroupName),
    GroupPid ! stop,
    unregister(GroupName).
