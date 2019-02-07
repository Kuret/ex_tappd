defmodule ExTappd.MixProject do
  use Mix.Project

  @description """
    Elixir wrapper for the Untappd for Business API
  """

  def project do
    [
      app: :ex_tappd,
      version: "0.0.1",
      elixir: "~> 1.8",
      name: "ExTappd",
      description: @description,
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/Kuret/ex_tappd",
      homepage_url: "https://github.com/Kuret/ex_tappd",
      deps: deps(),
      docs: [extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:plug, ">= 1.4.5"},
      {:mock, "~> 0.1.1", only: :test},
      {:ex_doc, "~> 0.18.3", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Rick Littel"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Kuret/ex_tappd"}
    ]
  end
end
