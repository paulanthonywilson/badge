defmodule BadgeFw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "linkit"

  def project do
    [app: :badge_fw,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.1.4"],
     deps_path: "../../deps",
     build_path: "../../_build/#{@target}",
     config_path: "../../config/config.exs",
     lockfile: "../../mix.lock",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(Mix.env),
     deps: deps ++ system(@target, Mix.env)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {BadgeFw, []},
     applications: applications(Mix.env)]
  end

  def applications(:prod), do: [:nerves_interim_wifi, :nerves_ntp | general_applications]
  def applications(_), do: general_applications

  def general_applications do
    [:logger, :badge_lib, :badge_settings]
  end

  def deps do
    [{:nerves, "~> 0.3.0"},
     {:nerves_interim_wifi, "~> 0.1", only: :prod},
     {:nerves_ntp, "~> 0.1", only: :prod},
     {:badge_lib, in_umbrella: true},
     {:badge_settings, in_umbrella: true},
     {:dummy_nerves, in_umbrella: true, only: [:dev, :test]}
    ]
  end

  def system(target, :prod) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end
  def system(_, _), do: []

  def aliases(:prod) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
  def aliases(_), do: []
end
