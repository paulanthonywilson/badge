defmodule BadgeLib.Mixfile do
  use Mix.Project

  def project do
    [app: :badge_lib,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: applications(Mix.env)]
  end


  def applications(:prod), do: [:firmata | general_applications]
  def applications(_), do: general_applications

  def general_applications do
    [:logger, :oauth, :extwitter, :poison]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:firmata, github: "mobileoverlord/firmata", only: :prod},
     {:oauth, github: "tim/erlang-oauth"},
     {:dummy_nerves, in_umbrella: true, only: [:dev, :test]},
     {:extwitter, "~> 0.6"},
     {:poison, "~> 2.2"}]
  end
end
