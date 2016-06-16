# Account Kit

An api client for Facebook Account Kit

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add account_kit to your list of dependencies in `mix.exs`:

        def deps do
          [{:account_kit, "~> 0.0.1"}]
        end

  2. Ensure account_kit is started before your application:

        def application do
          [applications: [:account_kit]]
        end

## Required Configuration
You must supply the below credentials. You will receive a reminder error if they are missing.

You should add the below snippet to config/config.exs or an environment specific config file
if you are using multiple facebook developer accounts for environments.

      config :account_kit,
        api_version: "v1.0",
        app_id: "valid_app_id",
        app_secret: "valid_app_secret",
        client_token: "valid_client_token",
        require_appsecret: true


## Recommended Testing Setup
First setup acccount kit in your facebook developer account.

Next install a web client to test with:
* `git clone https://github.com/santiblanko/Account-kit-sample-for-web`
* `cd Account-kit-sample-for-web`
* Modify the JS login callback to log the auth code to console instead of into an html element (I get an error if an HTML element is used).
* `python -m SimpleHTTPServer 9000`
* Have chrome console open and preserving logs
* Fill out the email or phone form to test either flow.
* Check the chrome console for the auth code
* You can then use the auth code with the api calls available in this client


## Contributing

Pull requests are welcomed. Before submitting your pull request, please run:
* `mix credo --strict`
* `mix coveralls`
* `mix dialyzer`

If there are any issues they should be corrected before submitting a pull request
