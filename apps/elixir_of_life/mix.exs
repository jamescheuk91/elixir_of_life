defmodule ElixirOfLife.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_of_life,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ElixirOfLife.Application, []},
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
  defp deps do
    [
      {:color_utils, git: "https://github.com/ehtb/color_utils.git"}
    ]
  end
end
