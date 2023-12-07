-module(projectGroup).
-export([start/1, add/3, notify/2]).

%List of members%
loop(Id, Members) ->
    receive
        {From, {add, Member, Ids}} ->
            From ! {self(), ok},
            notify(Members, Member),
            loop(Id, [{Member, Ids}| Members]);
        {From, get_members} ->
            From ! {self(), Members},
            loop(Id, Members);
        {From, Members} ->
           From ! {self(), acknowledged} 
    end.

%add a member%
add(Server, Id, Member) ->
    Server ! {self(), {add, Member, Id}},
    receive
        {Server, ok} ->
            ok
    end.

%notify all members of the group about the new member%
notify (Members, NewMember) ->
    lists:foreach(fun({Member, Id})->
        Member ! {new_member, NewMember},
        receive 
            {Id, acknowledged} -> ok
        end
    end, Members).


start(Id) ->
    spawn(fun()-> loop(Id, []) end).
