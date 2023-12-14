defmodule GmsWeb.PingView do
  use GmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :response, "")}
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <.button variant="outlined" color="warning" phx-click="ping">Ping Backend</.button>
    </div>
    <div class="grid grid-cols-3 gap-4">
      <p>Response: <%= @response %></p>
    </div>
    """
  end

  def handle_event("ping", _params, socket) do
    # remote procedure call (RPC) to another node in the system
    # :ping_pong_server: This is the name of the remote node
    # :ping: function you wanna call on the remote node
    # :infinity: we wait for the call no mather how long it takes
    #IO.inspect(:rpc.call(:ping_pong_server, :ping, [], :infinity))
    case :rpc.call(:ping_pong_server, :ping, [], :infinity) do
      :pong ->
        {:noreply, assign(socket, :response, "Received Pong from Backend")}
      _ ->
        {:noreply, assign(socket, :response, "Error")}
    end
  end
end
