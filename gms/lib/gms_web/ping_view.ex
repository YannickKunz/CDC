defmodule GmsWeb.PingView do
  use GmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :response, "")}
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4">
      <.button variant="outlined" color="warning" phx-click="send_message">Send Message</.button>
    </div>
    <div class="grid grid-cols-3 gap-4">
      <p>Response: <%= @response %></p>
    </div>
    """
  end

  def handle_event("send_message", _params, socket) do
        # send a message from group3 on this node to group2 on the erlang node
        case :myP.send_message_to_group(:group3, :'erlangSide2@127.0.0.1', :group2 ,"Hello from group1 on the elixir frontend") do
          _ -> {:noreply, assign(socket, :response, "Successful" )}
        end
  end
end
