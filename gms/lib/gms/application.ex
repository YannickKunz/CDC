defmodule Gms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do

    Node.start(:'elixirSide@127.0.0.1')
    # Create a node for the elixir frontend
    Logger.info("self(): #{inspect(self())}")
    Logger.info("Local node alive: #{inspect(Node.alive?)}")
    # Connect this node with an erlang node (the erlang node needs to be created before running this code)
    Node.connect(:"erlangSide@127.0.0.1")
    Logger.info("Inspect Node.connect(:'erlangSide@127.0.0.1'): #{inspect(Node.connect(:"erlangSide@127.0.0.1"))}")
    Logger.info("Node.list(): #{inspect(Node.list())} - This shows all visible nodes in the system excluding the local node.")
    # Register a name to the local node
    Process.register(self(), :node)
    case :myP.start(:group3, 5) do
      {:ok, group_name} -> Logger.info("Group_name start: #{inspect(group_name)}")
    end


    #current_dir = File.cwd!()

    # Path to erlang code
    #erlang_module_path = Path.join([current_dir, "lib", "gms", "server"]) |> IO.chardata_to_string()

    #IO.inspect(current_dir, label: "Current Directory")
    #IO.inspect(erlang_module_path, label: "Erlang Module Path")

    # Ensure the path is added to the Erlang code path
    #:code.add_pathz(erlang_module_path |> to_charlist)

    children = [
      GmsWeb.Telemetry,
      Gms.Repo,
      {DNSCluster, query: Application.get_env(:gms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Gms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gms.Finch},
      # start ping pong server
      #{ :ping_pong_server, {Gms.Server.PingPongServer, :start_link, [[]]} },
      # %{id: PingPongServer, start: {:ping_pong_server,:start_link, []} },
      # Start a worker by calling: Gms.Worker.start_link(arg)
      # {Gms.Worker, arg},
      # Start to serve requests, typically the last entry
      GmsWeb.Endpoint
    ]


    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gms.Supervisor]
    Supervisor.start_link(children, opts)

  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
