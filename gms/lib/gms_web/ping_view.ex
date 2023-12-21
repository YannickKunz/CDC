defmodule GmsWeb.PingView do
  use GmsWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :response, "")}
  end

  # Button & response field
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <.button phx-click="send_message">Message To Backend</.button>
    </div>
    <div class="grid grid-cols-3 gap-4">
      <p>Response: <%= @response %></p>
    </div>
    """
  end

  def handle_event("send_message", _params, socket) do
    Logger.info "Start of the event >>>>>>>>>>>>>>>>>"

    # Create a node for the elixir frontend
    Node.start(:'elixirSide@127.0.0.1')
    Logger.info("self(): #{inspect(self())}")
    Logger.info("Local node alive: #{inspect(Node.alive?)}")
    # Connect this node with an erlang node (the erlang node needs to be created before running this code)
    Node.connect(:"erlangSide@127.0.0.1")
    Logger.info("Inspect Node.connect(:'erlangSide@127.0.0.1'): #{inspect(Node.connect(:"erlangSide@127.0.0.1"))}")
    Logger.info("Node.list(): #{inspect(Node.list())} - This shows all visible nodes in the system excluding the local node.")
    # Register a name to the local node
    Process.register(self(), :node)
    # Send a message to the erlang node to check the connection
    Process.send({:node, :"erlangSide@127.0.0.1"}, {:hello, :from, self()}, [])
    # create a group named group3 with 5 processes
    case :myP.start(:group3, 5) do
      {:ok, group_name} -> {:noreply, assign(socket, :response, group_name)}; Logger.info("#{inspect(group_name)}")
    end
    # send a message from group3 on this node to group2 on the erlang node
    case :myP.send_message_to_group(:group3, :'erlangSide@127.0.0.1', :group2 ,"Hello from the elixir frontend") do
      _ -> {:noreply, assign(socket, :error_logger, "Successful" )}
    end
  end
end
