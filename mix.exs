defmodule AccountKit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :account_kit,
      build_embedded: Mix.env == :prod,
      deps: deps,
      dialyzer: [
        plt_add_deps: true,
        plt_file: ".local.plt"
      ],
      description: "Facebook Account Kit api client",
      docs: [extras: ["README.md"]],
      elixir: "~> 1.2",
      homepage_url: "https://github.com/br/account_kit",
      name: "Account Kit",
      package: package,
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "vcr": :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ],
      source_url: "https://github.com/br/account_kit",
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.0.1"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:httpoison, :poison]]
  end

  defp deps do
    [
      {:credo,       "~> 0.3",  only: [:dev]},
      {:dialyxir,    "~> 0.3",  only: [:dev]},
      {:earmark,     "~> 0.1",  only: [:dev]},
      {:excoveralls, "~> 0.5",  only: [:test]},
      {:ex_doc,      "~> 0.11", only: [:dev]},
      {:exvcr,       "~> 0.7",  only: [:test]},
      {:httpoison,   "~> 0.8"},
      {:poison,      "~> 1.5"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/br/account_kit"},
      maintainers: ["John Kelly"]
    ]
  end
end
