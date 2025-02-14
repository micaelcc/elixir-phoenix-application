defmodule ElixirPhoenixApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirPhoenixAppWeb.Telemetry,
      ElixirPhoenixApp.Repo,
      {DNSCluster, query: Application.get_env(:elixir_phoenix_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirPhoenixApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirPhoenixApp.Finch},
      # Start a worker by calling: ElixirPhoenixApp.Worker.start_link(arg)
      # {ElixirPhoenixApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirPhoenixAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirPhoenixApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirPhoenixAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
