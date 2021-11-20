defmodule Namedays.MixProject do
  use Mix.Project

  def project do
    [
      app: :namedays,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Namedays.Application, []},
      env: [
        content_files: [
          'priv/resources/namedays.json',
          'priv/resources/namedays-extended.json'
        ],
        timezone: "Europe/Riga"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:tzdata, "~> 1.1"},
      {:mox, "~> 1.0", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
