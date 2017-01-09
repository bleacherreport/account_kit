defmodule AccountKit do
  @moduledoc """
  Facebook Account Kit
  """
  @type decoded_json  :: %{String.t => (String.t | non_neg_integer)}
  @type http_response :: {:ok, decoded_json} | {:error, decoded_json}

  @doc """
  Takes a short term authorization code & returns
  a long term access token, refresh interval, & id.
  GET https://graph.accountkit.com/v1.0/access_token
  """
  @spec access_token(String.t) :: http_response
  def access_token(code) do
    query_params = [
      "grant_type=authorization_code",
      "code=#{code}",
      "access_token=#{server_token()}",
      appsecret_proof_param(server_token(), require_appsecret)
    ]
    |> Enum.reject(&(&1 == nil))
    |> Enum.join("&")

    case HTTPoison.get! "#{fqdn()}/access_token?#{query_params}" do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, Poison.decode!(body)}
      %HTTPoison.Response{body: body} ->
        {:error, Poison.decode!(body)["error"]}
    end
  end

  @doc """
  Delete an account kit account.
  DELETE https://graph.accountkit.com/v1.0/<account_id>
  """
  @spec delete_account(String.t, String.t) :: http_response
  def delete_account(account_id, access_token) do
    query_params = [
      "access_token=#{server_token()}",
      appsecret_proof_param(access_token, require_appsecret)
    ]
    |> Enum.reject(&(&1 == nil))
    |> Enum.join("&")

    case HTTPoison.delete! "#{fqdn()}/#{account_id}?#{query_params}" do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, %{}}
      %HTTPoison.Response{body: body} ->
        {:error, Poison.decode!(body)["error"]}
    end
  end

  @doc """
  Returns metadata about the user.
  https://graph.accountkit.com/v1.0/me
  """
  @spec me(String.t) :: http_response
  def me(access_token) do
    query_params = [
      "access_token=#{access_token}",
      appsecret_proof_param(access_token, require_appsecret)
    ]
    |> Enum.reject(&(&1 == nil))
    |> Enum.join("&")

    case HTTPoison.get! "#{fqdn()}/me?#{query_params}" do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, Poison.decode!(body)}
      %HTTPoison.Response{body: body} ->
        {:error, Poison.decode!(body)["error"]}
    end
  end

  @doc """
  Determines if the given id matches
  the given access token's associated id.
  """
  @spec valid_access_token?(String.t, String.t) :: boolean
  def valid_access_token?(access_token, id) do
    case me(access_token) do
      {:ok, %{"id" => response_id}} ->
        id == response_id
      {:error, _} ->
        false
    end
  end

  defp api_version,       do: Application.fetch_env!(:account_kit, :api_version)
  defp app_id,            do: Application.fetch_env!(:account_kit, :app_id)
  defp app_secret,        do: Application.fetch_env!(:account_kit, :app_secret)
  defp require_appsecret, do: Application.fetch_env!(:account_kit, :require_appsecret)
  defp fqdn,              do: "https://graph.accountkit.com/#{api_version()}"
  defp server_token,      do: "AA|#{app_id()}|#{app_secret()}"

  @spec appsecret_proof_param(String.t, boolean) :: (String.t | nil)
  defp appsecret_proof_param(_access_token, false), do: nil
  defp appsecret_proof_param(access_token, true) do
    appsecret_proof =
      :sha256
      |> :crypto.hmac(app_secret(), access_token)
      |> Base.encode16(case: :lower)

    "appsecret=#{appsecret_proof}"
  end
end
