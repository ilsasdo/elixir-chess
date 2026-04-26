defmodule Chess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Commanded.Application, otp_app: :chess, event_store: [
    adapter: EventStore.Adapters.Postgres,
    event_store: Chess.Infrastructure.EventStore]

  @impl true
  def start(_type, _args) do
    children = [
#      ChessWeb.Telemetry,
#      Chess.Repo,
#      {DNSCluster, query: Application.get_env(:elixir_chess, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Chess.PubSub},
      # Start a worker by calling: Chess.Worker.start_link(arg)
      # {Chess.Worker, arg},
      # Start to serve requests, typically the last entry
      ChessWeb.Endpoint,
      Chess.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
