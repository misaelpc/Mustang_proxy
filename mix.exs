defmodule Mustang.Mixfile do
  use Mix.Project

  def project do
    [app: :mustang,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Mustang, []},
     applications: [:phoenix, :cowboy, :logger, :ecto, :tds_ecto, :ibrowse, :httpotion,:uuid]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.9.0"},
     {:cowboy, "~> 1.0"},
     {:tds_ecto, "~> 0.1"},
     {:ecto, "~> 0.8.1"},
     {:uuid, "~> 0.1.5" },
     {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"},
     {:httpotion, "~> 2.0.0"}]
  end
end
