defmodule ExercismElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exercism_elixir,
      version: "0.0.1",
      elixir: "~> 1.3",
      deps: deps(),
      dialyzer: [paths: ["tmp/build"]]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:dialyxir, "~> 0.5"}
    ]
  end
end
