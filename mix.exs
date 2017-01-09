defmodule AccountKit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :account_kit,
      build_embedded: Mix.env == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: true,
        plt_file: ".local.plt"
      ],
      description: "Facebook Account Kit api client",
      docs: [extras: ["README.md"]],
      elixir: "~> 1.2",
      homepage_url: "https://github.com/bleacherreport/account_kit",
      name: "Account Kit",
      package: package(),
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
      source_url: "https://github.com/bleacherreport/account_kit",
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.0.1"
    ]
  end

  def application do
    [applications: [:httpoison, :poison]]
  end

  defp deps do
    [
      {:credo,       "~> 0.5",  only: [:dev]},
      {:dialyxir,    "~> 0.4",  only: [:dev]},
      {:earmark,     "~> 1.0",  only: [:dev]},
      {:ex_doc,      "~> 0.14", only: [:dev]},
      {:excoveralls, "~> 0.6",  only: [:test]},
      {:exvcr,       "~> 0.8",  only: [:test]},
      {:httpoison,   "~> 0.11.0"},
      {:poison,      "~> 1.5 or ~> 2.0 or ~> 3.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/bleacherreport/account_kit"},
      maintainers: ["John Kelly"]
    ]
  end
end
