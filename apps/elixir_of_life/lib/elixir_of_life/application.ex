defmodule ElixirOfLife.Application do
  @moduledoc """
  The ElixirOfLife Application Service.

  The elixir_of_life system lives in this application.
  """
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      %{
        id: ElixirOfLife.BoardServer,
        start: {ElixirOfLife.BoardServer, :start_link, []},
        restart: :permanent,
        type: :worker
      },
      %{
        id: ElixirOfLife.EventWorker,
        start: {ElixirOfLife.EventWorker, :start_link, []},
        restart: :permanent,
        type: :worker
      },
      %{
        id: ElixirOfLife.GenerationTicker,
        start: {ElixirOfLife.GenerationTicker, :start_link, []},
        restart: :permanent,
        type: :worker
      },
      # %{
      #   id: ElixirOfLife.GameRunner,
      #   start: {ElixirOfLife.GameRunner, :start_link, []},
      #   retart: :permanent,
      #   type: :worker
      # },
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
