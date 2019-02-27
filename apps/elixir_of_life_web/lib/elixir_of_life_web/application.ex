defmodule ElixirOfLifeWeb.Application do
  @moduledoc """
  The ElixirOfLifeWeb Application Service.

  The elixir_of_life_web system admin web interface lives in this application.
  """
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      %{
        id: ElixirOfLifeWeb.Endpoint,
        start: {ElixirOfLifeWeb.Endpoint, :start_link, []},
        restart: :permanent,
        type: :supervisor
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirOfLifeWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirOfLifeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
