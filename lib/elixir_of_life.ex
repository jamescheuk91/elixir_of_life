defmodule ElixirOfLife do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(ElixirOfLife.Endpoint, []),
      # Start your own worker by calling: ElixirOfLife.Worker.start_link(arg1, arg2, arg3)
      # worker(ElixirOfLife.Worker, [arg1, arg2, arg3]),
      worker(ElixirOfLife.BoardServer, []),
      worker(ElixirOfLife.EventWorker, []),
      worker(ElixirOfLife.GenerationTickerWorker, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirOfLife.Supervisor]
    supervisor_start_link_status = Supervisor.start_link(children, opts)
    spawn(fn ->
      ElixirOfLife.GameRunner.run()
    end)
    supervisor_start_link_status
  end



  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirOfLife.Endpoint.config_change(changed, removed)
    :ok
  end
end
