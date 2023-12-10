-module(myP).
-export([start/2, create_processes/2, group_loop/2, process/0,
list_members/1,send_message/2, send_message_to_group/3, 
send_message_to_group/4, add_process/1, delete_process/2, delete_group/1]).

% start/2 function starts the group with a given name and number of processes.
start(GroupName, NumberOfProcesses) ->
    Pids = create_processes(NumberOfProcesses, []),
    register(GroupName, spawn(?MODULE, group_loop, [GroupName, Pids])),
    {ok, GroupName}.

% add_process/1 function adds a new process to a group.
add_process(GroupName) ->
    GroupPid = whereis(GroupName),
    NewProcessPid = spawn(?MODULE, process, []),
    GroupPid ! {add_process, NewProcessPid}.

% delete_process/2 function deletes a specific process from a group.
delete_process(GroupName, ProcessPid) ->
    GroupPid = whereis(GroupName),
    GroupPid ! {delete_process, ProcessPid}.


% create_processes/2 function creates the specified number of processes.
create_processes(0, Acc) ->
    lists:reverse(Acc);
create_processes(N, Acc) ->
    Pid = spawn(?MODULE, process, []),
    create_processes(N - 1, [Pid | Acc]).

% group_loop/2 function initializes the group with the given name and processes.
group_loop(GroupName, Pids) ->
    io:format("Initializing group ~p with members ~p~n", [GroupName, Pids]),
    group_loop(GroupName, Pids, []).

% group_loop/3 function handles the messages sent to the group.
group_loop(_GroupName, [], Members) ->
    receive
        {join, MemberPid} ->
            io:format("Member ~p joined group~n", [MemberPid]),
            group_loop(_GroupName, [], [MemberPid | Members]);
        {list_members, Requester} ->
            Requester ! {list_members_response, get_members(Members)},
            group_loop(_GroupName, [], Members);
        {send_message, Message} ->
            lists:foreach(fun(Member) -> Member ! Message end, Members),
            group_loop(_GroupName, [], Members);
        {send_message_to_group, TargetGroupPid, Message} ->
            TargetGroupPid ! {send_message, Message},
            group_loop(_GroupName, [], Members);
        {add_process, NewProcessPid} ->
            group_loop(_GroupName, [], [NewProcessPid | Members]);
        {delete_process, ProcessPid} ->
            NewMembers = lists:delete(ProcessPid, Members),
            group_loop(_GroupName, [], NewMembers);
        stop ->
            lists:foreach(fun(Member) -> Member ! stop end, Members)
    end;



group_loop(GroupName, [Pid | RestPids], Members) ->
    group_loop(GroupName, RestPids, [Pid | Members]).

% get_members/1 function returns the list of members in the group.
get_members(Members) ->
    lists:reverse(Members).

% process/0 function waits for a message.
process() ->
    receive
        Message when Message =/= stop ->
            io:format("Process ~p received message ~p~n", [self(), Message]),
            process();
        stop ->
            exit(normal)
    end,
    process().


% list_members/1 function lists the members of the specified group.
list_members(GroupName) ->
    register(list_members_requester, self()),
    GroupPid = whereis(GroupName),
    GroupPid ! {list_members, list_members_requester},
    receive
        {list_members_response, Members} ->
            unregister(list_members_requester),
            {ok, Members}
    end.

% send_message/2 function sends a message to all processes in a group.
send_message(GroupName, Message) ->
    GroupPid = whereis(GroupName),
    GroupPid ! {send_message, Message}.

% send_message_to_group/3 function sends a message to another group.
send_message_to_group(SourceGroupName, TargetGroupName, Message) ->
    SourceGroupPid = whereis(SourceGroupName),
    TargetGroupPid = whereis(TargetGroupName),
    SourceGroupPid ! {send_message_to_group, TargetGroupPid, Message}.

% send_message_to_group/4 function sends a message to another group on another node.
send_message_to_group(SourceGroupName, TargetNodeName, TargetGroupName, Message) ->
    SourceGroupPid = whereis(SourceGroupName),
    TargetGroupPid = rpc:call(TargetNodeName, erlang, whereis, [TargetGroupName]),
    SourceGroupPid ! {send_message_to_group, TargetGroupPid, Message}.

% delete_group/1 function deletes all processes in a group and deletes the group.
delete_group(GroupName) ->
    GroupPid = whereis(GroupName),
    GroupPid ! stop,
    unregister(GroupName).