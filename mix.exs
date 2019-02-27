defmodule ElixirOfLife.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.8.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:distillery, "~> 2.0.9", runtime: false},
      {:excoveralls, "~> 0.10.0", only: :test, runtime: false},
      {:edeliver, "~> 1.6.0", runtime: false}
    ]
  end

  defp aliases do
    [
      unit_test: ["ecto.create --quiet", "ecto.migrate", "test --only unit_test"],
      controller_test: ["ecto.create --quiet", "ecto.migrate", "test --only controller_test"],
      integration_test: ["ecto.create --quiet", "ecto.migrate", "test --only integration_test"],
      e2e_test: ["ecto.create --quiet", "ecto.migrate", "test --only e2e_test"]
      # sentry_recompile: ["clean", "compile"]
    ]
  end
end
