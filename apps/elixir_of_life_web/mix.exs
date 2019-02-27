defmodule ElixirOfLifeWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_of_life_web,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "1.7.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ElixirOfLifeWeb.Application, []},
      extra_applications: [:logger, :runtime_tools],
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps() do
    [
      {:plug_cowboy, "~> 2.0.1"},
      {:plug, "~> 1.7.2"},
      {:phoenix, "1.4.0"},
      {:phoenix_pubsub, "1.1.0"},
      {:phoenix_ecto, "4.0.0"},
      {:phoenix_html, "2.12.0"},
      {:phoenix_live_reload, "~> 1.1.5", only: :dev},
      {:gettext, "0.16.0"},
      {:jason, "~> 1.1.2"},
      {:sentry, "~> 6.4.1"},
      {:elixir_of_life, in_umbrella: true}
    ]
  end

  defp aliases() do
    []
  end
end
