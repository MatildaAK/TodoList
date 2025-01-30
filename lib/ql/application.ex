defmodule Ql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      QlWeb.Telemetry,
      Ql.Repo,
      {DNSCluster, query: Application.get_env(:ql, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ql.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ql.Finch},
      # Start a worker by calling: Ql.Worker.start_link(arg)
      # {Ql.Worker, arg},
      # Start to serve requests, typically the last entry
      QlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
