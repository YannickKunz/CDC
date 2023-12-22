How to run our service without the frontend (Example using 3 terminals)
In order to access our code you can go to our repository on github and clone the project to your local environment (link to repository).
After this open three new terminals and navigate our backend code (file: myP.erl) which you find in the project in the folder CDC\gms\src.
·	In terminal1 enter : “erl -name ‘node1@127.0.0.1’ “
·	In terminal2 enter : “erl -name ‘node2@127.0.0.1’ “
·	In terminal3 enter : “erl -name ‘node3@127.0.0.1’ “
This creates a node for each terminal with its hostname.For the next step you need to connect the nodes together (this step is optional, but it is used to ensure that the nodes are connected): 
·	Connect node1 with node2 and node1 with node3 in terminal1 using :
o	net_adm:ping(‘node2@127.0.0.1’).
o	 net_adm:ping(‘node3@127.0.0.1’).
·	After that connect node2 with node3 using:
o	“net_adm:ping(‘node3@127.0.0.1’).”
These 3 commands should return “pong” if it worked or “pang” if it did not work.
Now the Erlang code can be compiled on each node using 
·	c(myP).
Each node can use the function start//2 in order to start one or multiple groups on each terminal using:
·	myP:start(group1, 3).
The first parameter (group1) is the name of the group and the second parameter (3) defines how much processes it will spawn. These processes are immediately added to the group.Important: For each group a new group name is required. 
After creating at least one group per node, you can start trying out the provided functionalities:
1.	The first functionality is simply sending a message from group1 to itself or to another group on the same node by running the command:
a.	myP:send_message(group1, “Hello”).This sends the message “Hello” to each process in group1.

2.	The second functionality is sending a message from group1 to group2, which runs on the same node by running the command:
a.	myP:send_message_to_group(group1, group2, “Hello from group1”).

3.	The third functionality sends a message from a group on a node to a group on another node by running the code:
a.	myP:send_message_to_group(group1, ‘node2@127.0.0.1’, group2, “Hello from group1 on node1”)This command takes group1 as the source group (first parameter), node2@127.0.0.1 as the target node (second parameter), group2 as the target  group (third parameter) and the “Hello from group1 on node1” as message (fourth parameter). Terminal2 should now display for each process in group2 the received message.
Send_message_to_group on terminal one:

Result on terminal two:

4.	The fourth functionality is adding a proces to a group by running the command:
a.	myP:add_process(group1).
5.	The fifth functionality is deleting a process with: 
a.	myP:delete_process(group1,<0.127.0>).Here the <0.127.0>” is the name of the process that you want to delete.
6.	The sixth functionality retuns a list of all the processes in a group with:
a.	myP:list_members(group1). 
7.	And finally, with the last function you can delete an entire group with:
a.	myP:delete_group(group1).
As you can see below, everything work and the code throws an exception when trying to list the members of group1 after having deleted the entire group.

The third terminal (both nodes received a:

How to run our service with the frontend
In order to be able to run the frontend the following technologies are required: 
·	Erlang 24 or later
·	Elixir 1.14 or later
·	Phoenix
·	PostgreSQL
Once you have them installed you can pull the project from github (link to repository). After this you can open it with Visual Studio Code (VSC) or your preferred Editor. In VSC you can open the terminal. Ensure that you are in the folder CDC\gms of the project. 
This is the terminal where we are going to run the frontend with Elixir. Before we do this it’s necessary that we open an additional terminal and setup the backend:
To do this open a new terminal and navigate to the src folder in the gms project (CDC\gms\src). Then run the instructions displayed below in the screenshot to create a node in Erlang and prepare it for the connection with another node. 
First a new node in a new terminal is created and registered it with the name node. This way the process identifier (Pid) is associated with this name which is then the global reference to this process so that other processes in the system can use it to communicate easily with this process: For the second message you need to create another Terminal with “erl -name erlangSide2@127.0.0.1” and compile the code in it and use “myP:start(group2, 3).” for example for it to work, for both terminal the group names need to be “group2”

You can also already load the myP.erl file which contains our code for the backend. Just enter the following command:

After this you can go back to the other terminal, navigate to the gms project and start the Phoenix project: 
Before you can run the frontend you need to create the database with
mix ecto.create
If you get an error while running this you have to make sure that your postgresql configurations for the project are set right. We used the username postgres and the password 123. You can find these configurations in CDC\gms\configs in the file dev.exs.
If the command worked, everything should be ready to run the frontend:

The project should run now and is available over the following address: localhost:4000/ping
If you want to see the frontend design we wanted you can see it at localhost:4000
This will display the basic frontend created with Phoenix. The site contains two buttons “Start” and “Send message”. If you click on the start button, you will generate a node on the elixir side aswell as 2 groups with a few processes each. Then, if you press send message, it should send the messages from the Elixir frontend to the erlang backend and inversely (in the picture below, I sent a message from the Erlang backend to the Elixir frontend).


If you look at the terminals you should see some additional information that tells more about  what has worked and if the message was received by the backend:

Hint: you can open additional terminals here as well and connect them in the same way as described in the subchapter: How to run our service without the frontend (Example using 3 terminals)
