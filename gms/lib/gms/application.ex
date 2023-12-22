defmodule Gms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  require Logger
  @impl true
  def start(_type, _args) do
    # Create a node for the elixir frontend
    Node.start(:'elixirSide@127.0.0.1')
    #Logger.info("self(): #{inspect(self())}")
    #Logger.info("Local node alive: #{inspect(Node.alive?)}")
    # Connect this node with an erlang node (the erlang node needs to be created before running this code)
    Node.connect(:"erlangSide@127.0.0.1")
    #Logger.info("Inspect Node.connect(:'erlangSide@127.0.0.1'): #{inspect(Node.connect(:"erlangSide@127.0.0.1"))}")
    #Logger.info("Node.list(): #{inspect(Node.list())} - This shows all visible nodes in the system excluding the local node.")
    # Register a name to the local node
    Process.register(self(), :node)
    # Send a message to the erlang node to check the connection
    # Process.send({:node, :"erlangSide@127.0.0.1"}, {:hello, :from, self()}, [])
    # create a group named group3 with 5 processes
    case :myP.start(:group3, 5) do
      {:ok, group_name} -> Logger.info("####################################################### application.ex group_name #{inspect(group_name)}")
    end
    children = [
      GmsWeb.Telemetry,
      Gms.Repo,
      {DNSCluster, query: Application.get_env(:gms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Gms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gms.Finch},
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
