defmodule GmsWeb.PingView do
  use GmsWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :response, "")}
  end

  def render(assigns) do
    ~H"""
    <div class="card">
            <div class="card-body">
                <h1 class="card-title">Distributed Membership Service with Atomic Multicast</h1>
            </div>
        </div>
        <div class="card mt-3">
            <div class="card-body">
                <input type="text" id="createGroupName" placeholder="Group Name">
                <input type="number" id="numberOfProcesses" placeholder="Number of Processes">
                <.button class="btn btn-primary" id="createGroup" onclick="createGroup()">Create group</.button>
            </div>
        </div>
        <div id="groupsContainer" class="groups-container"></div>
        <script>
        function createGroup() {
          var groupName = document.getElementById('createGroupName').value;
          var numberOfProcesses = document.getElementById('numberOfProcesses').value;

          // Create a new div for the group
          var groupDiv = document.createElement('div');
          groupDiv.className = 'group';

          // Add group name to the div
          var groupNameH2 = document.createElement('h2');
          groupNameH2.textContent = groupName;
          groupDiv.appendChild(groupNameH2);

          // Add process names to the div
          for (var i = 0; i < numberOfProcesses; i++) {
            var processName = 'Process ' + (i + 1);
            var processP = document.createElement('p');
            processP.textContent = processName;
            groupDiv.appendChild(processP);
          }

          // Add the div to the groups container
          var groupsContainer = document.getElementById('groupsContainer');
          groupsContainer.appendChild(groupDiv);
        }

        </script>
        <style>
        .card {
          box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
          transition: 0.3s;
          width: 80%;
          border-radius: 5px;
          margin: auto;
          padding: 20px;
      }

      .card:hover {
          box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
      }

      .container {
          padding: 2rem;
          text-align: center;
      }

      .btn-primary {
          background-color: #007bff;
          border-color: #007bff;
          color: #fff;
          margin-top: 5px;
          margin-left: auto;
          text-align: center;
      }

      .groups-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
      }

      .group {
        flex: 0 0 calc(33% - 20px); /* This will create 3 groups per row */
        box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
        transition: 0.3s;
        border-radius: 5px;
        margin: 10px;
        padding: 20px;
        }

      .card {
          flex: 0 0 calc(50% - 20px);
          display: flex;
          align-items: center;
          flex-direction: column;
      }

      .card-body {
          display: block;
          flex-direction: column;
          align-items: center;
      }

      .btn {
          padding: 5px 10px;
          width: 150px;
          display: block;
          margin: 5px auto;
      }
        </style>
    """
  end

  def handle_event("ping", _params, socket) do
    Logger.info "PING >>>>>>>>>>>>>>>>>"
    # remote procedure call (RPC) to another node in the system
    # :ping_pong_server: This is the name of the remote node
    # :ping: function you wanna call on the remote node
    # :infinity: we wait for the call no mather how long it takes
    #IO.inspect(:rpc.call(:ping_pong_server, :ping, [], :infinity))

    # GenServer.call(PingPongServer, :ping)
    Logger.info :ping_pong_server.hello()
    # case :ping_pong_server.ping() do
    # # case :rpc.call(:ping_pong_server, :ping, [], :infinity) do
    #   :pong ->
    #     {:noreply, assign(socket, :response, "Received Pong from Backend")}
    #   _ ->
    #     {:noreply, assign(socket, :response, "Error")}
    # end
    {:noreply, assign(socket, :response, "ASDF")}
    Logger.info :myP.start(:group1, 3)
      case :myp.start() do
        :ok ->
          {:noreply, assign(socket, :response, "Started")}
        _ ->
          {:noreply, assign(socket, :response, "Error")}
      end


  end
end
