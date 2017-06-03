defmodule ExPublica.Mixfile do
  use Mix.Project

  def project do
    [app: :expublica,
     version: "0.1.0",
     elixir: "~> 1.4",
     source_url: "https://github.com/dotdotdotpaul/expublica",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package()]
  end

  def package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Paul Clegg"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/dotdotdotpaul/expublica"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {ExPublica.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 3.0"},
      {:httpoison, "~> 0.11.1"}
    ]
  end
end
