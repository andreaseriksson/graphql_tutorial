defmodule GraphqlTutorialWeb.Schema.LoginUserTest do
  use GraphqlTutorialWeb.ConnCase, async: false

  import GraphqlTutorial.AccountsFixtures

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  @query """
    mutation ($email: String!, $password: String!) {
      session: createSession(email: $email, password: $password) {
        token
      }
    }
  """

  defp get_post_args(:correct) do
    user = user_fixture()

    %{
      query: @query,
      variables: %{
        "email" => user.email,
        "password" => valid_user_password()
      }
    }
  end

  defp get_post_args(:incorrect) do
    %{
      query: @query,
      variables: %{
        "email" => "foo@example.com",
        "password" => "wrong"
      }
    }
  end

  test "create user mutation with correct credentials", %{conn: conn} do
    args = get_post_args(:correct)

    response =
      conn
      |> get_response(args)

    assert %{
             "data" => %{
               "session" => %{
                 "token" => "" <> _
               }
             }
           } = json_response(response, 200)
  end

  test "create user mutation with incorrect credentials", %{conn: conn} do
    args = get_post_args(:incorrect)

    response =
      conn
      |> get_response(args)

    assert %{
             "data" => %{
               "session" => nil
             },
             "errors" => [
               %{
                 "message" => "Incorrect email or password"
               }
             ]
           } = json_response(response, 200)
  end
end
