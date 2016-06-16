defmodule AccountKitTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "access_token - success with require_appsecret true" do
    use_cassette "access_token_success_appsecret_true" do
      cmd = AccountKit.access_token("valid_phone_auth_code")
      assert cmd == {:ok, %{
        "access_token"               => "valid_phone_access_token",
        "id"                         => "phone_facebook_id",
        "token_refresh_interval_sec" => 2592000
      }}
    end
  end

  test "access_token - success with require_appsecret false" do
    use_cassette "access_token_success_appsecret_false" do
      cmd = AccountKit.access_token("valid_email_auth_code")
      assert cmd == {:ok, %{
        "access_token"               => "valid_email_access_token",
        "id"                         => "email_facebook_id",
        "token_refresh_interval_sec" => 2592000
      }}
    end
  end

  test "access_token - failure" do
    use_cassette "access_token_failure" do
      cmd = AccountKit.access_token("invalid")
      assert cmd == {:error, %{
        "code"         => 2,
        "fbtrace_id"   => "C4erpIHwfYY",
        "is_transient" => true,
        "message"      => "Service temporarily unavailable",
        "type"         => "EMApiException"
      }}
    end
  end

  test "delete_account - success with require_appsecret true" do
    use_cassette "delete_account_success_appsecret_true" do
      cmd = AccountKit.delete_account("phone_facebook_id", "valid_phone_access_token")
      assert cmd == {:ok, %{}}
    end
  end

  test "delete_account - success with require_appsecret false" do
    use_cassette "delete_account_success_appsecret_false" do
      cmd = AccountKit.delete_account("email_facebook_id", "valid_email_access_token")
      assert cmd == {:ok, %{}}
    end
  end

  test "delete_account - failure" do
    use_cassette "delete_account_failure" do
      cmd = AccountKit.delete_account("invalid", "invalid")
      assert cmd == {:error, %{
        "code"         => 2,
        "fbtrace_id"   => "A4vROAvRZtP",
        "is_transient" => true,
        "message"      => "Service temporarily unavailable",
        "type"         => "EMApiException"
      }}
    end
  end

  test "me - email success with require_appsecret true" do
    use_cassette "me_success_email_with_appsecret_true" do
      cmd = AccountKit.me("valid_email_access_token")

      assert cmd == {:ok, %{
        "email" => %{
          "address" => "test@example.com",
        },
        "id" => "email_facebook_id"
      }}
    end
  end

  test "me - email success with require_appsecret false" do
    use_cassette "me_success_email_with_appsecret_false" do
      cmd = AccountKit.me("valid_email_access_token")

      assert cmd == {:ok, %{
        "email" => %{
          "address" => "test@example.com",
        },
        "id" => "email_facebook_id"
      }}
    end
  end

  test "me - phone success with require_appsecret true" do
    use_cassette "me_success_phone_with_appsecret_true" do
      cmd = AccountKit.me("valid_phone_access_token")

      assert cmd == {:ok, %{
        "id"    => "phone_facebook_id",
        "phone" => %{
          "country_prefix"  => "1",
          "national_number" => "9545555555",
          "number"          => "+19545555555",
        }
      }}
    end
  end

  test "me - phone success with require_appsecret false" do
    use_cassette "me_success_phone_with_appsecret_false" do
      cmd = AccountKit.me("valid_phone_access_token")

      assert cmd == {:ok, %{
        "id"    => "phone_facebook_id",
        "phone" => %{
          "country_prefix"  => "1",
          "national_number" => "9545555555",
          "number"          => "+19545555555",
        }
      }}
    end
  end

  test "me - failure" do
    use_cassette "me_failure" do
      cmd = AccountKit.me("invalid")
      assert cmd == {:error, %{
        "code"         => 190,
        "fbtrace_id"   => "CeRr0HW5x07",
        "message"      => "Invalid OAuth access token.",
        "type"         => "OAuthException"
      }}
    end
  end

  test "valid_access_token? - true with valid token" do
    use_cassette "me_success_email_with_appsecret_false" do
      cmd = AccountKit.valid_access_token?("valid_email_access_token", "email_facebook_id")
      assert cmd == true
    end
  end

  test "valid_access_token? - false with invalid token" do
    use_cassette "me_success_email_with_appsecret_false" do
      cmd = AccountKit.valid_access_token?("valid_email_access_token", "invalid")
      assert cmd == false
    end
  end

  test "valid_access_token? - false with facebook error" do
    use_cassette "me_failure" do
      cmd = AccountKit.valid_access_token?("invalid", "123")
      assert cmd == false
    end
  end
end
