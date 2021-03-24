defmodule Freshy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Freshy.Repo,
      # Start the Telemetry supervisor
      FreshyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Freshy.PubSub},
      # Start the Endpoint (http/https)
      FreshyWeb.Endpoint,
      # Starts an OIDC authorization child
      {OpenIDConnect.Worker, Application.get_env(:freshy, :openid_connect_providers)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Freshy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FreshyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
