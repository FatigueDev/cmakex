defmodule Cmakex.MixProject do
  use Mix.Project

  def project do
    [
      app: :cmakex,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "1.7.10", runtime: false, only: :dev},
      {:raylib,
       runtime: false,
       compile: false,
       app: false,
       git: "https://github.com/raysan5/raylib.git",
       tag: "5.5"}
    ]
  end
end
