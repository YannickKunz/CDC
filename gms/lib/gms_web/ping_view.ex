defmodule GmsWeb.PingView do
  use GmsWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :response, "")}
  end

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
    # remote procedure call (RPC) to another node in the system
    # :ping_pong_server: This is the name of the remote node
    # :ping: function you wanna call on the remote node
    # :infinity: we wait for the call no mather how long it takes
    #IO.inspect(:rpc.call(:ping_pong_server, :ping, [], :infinity))

    # GenServer.call(PingPongServer, :ping)
    #Logger.info :ping_pong_server.hello()
    # case :ping_pong_server.ping() do
    # # case :rpc.call(:ping_pong_server, :ping, [], :infinity) do
    #   :pong ->
    #     {:noreply, assign(socket, :response, "Received Pong from Backend")}
    #   _ ->
    #     {:noreply, assign(socket, :response, "Error")}
    # end
    #{:noreply, assign(socket, :response, "ASDF")}
    #iex --name app2
    Node.start(:'elixirSide@127.0.0.1')
    Logger.info("self(): #{inspect(self())}")
    Logger.info("Local node alive: #{inspect(Node.alive?)}")
    Node.connect(:"erlangSide@127.0.0.1")
    Logger.info("Inspect Node.connect(:'erlangSide@127.0.0.1'): #{inspect(Node.connect(:"erlangSide@127.0.0.1"))}")
    Logger.info("Node.list(): #{inspect(Node.list())} - This shows all visible nodes in the system excluding the local node.")
    Process.register(self(), :node2)
    Process.send({:node, :"erlangSide@127.0.0.1"}, {:hello, :from, self()}, [])
    #
    case :myP.start(:group3, 5) do
      {:ok, group_name} -> {:noreply, assign(socket, :response, group_name)}; Logger.info("#{inspect(group_name)}")
    end
    case :myP.send_message_to_group(:group3, :'erlangSide@127.0.0.1', :group2 ,"Hello from the elixir frontend") do
      _ -> {:noreply, assign(socket, :error_logger, "Successful" )}
    end
  end
end
