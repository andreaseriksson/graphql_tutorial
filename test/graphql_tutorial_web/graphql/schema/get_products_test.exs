defmodule GraphqlTutorialWeb.Schema.GetProductsTest do
  use GraphqlTutorialWeb.ConnCase, async: false
  import GraphqlTutorial.GraphqlTestHelpers

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  @query """
    query {
      products {
        id
      }
    }
  """

  defp get_post_args do
    %{
      query: @query
    }
  end

  # describe "when not logged in" do
  #   setup [:user_with_invalid_jwt, :with_product]
  #
  #   test "get products with invalid credentials", %{conn: conn} do
  #     args = get_post_args()
  #
  #     response =
  #       conn
  #       |> get_response(args)
  #
  #     assert %{
  #              "data" => %{"products" => nil},
  #              "errors" => [
  #                %{
  #                  "locations" => [_],
  #                  "message" => "Not Authorized",
  #                  "path" => ["products"]
  #                }
  #              ]
  #            } = json_response(response, 200)
  #   end
  # end

  describe "when logged in" do
    setup [:user_with_valid_jwt, :with_product]

    test "get products with valid credentials", %{conn: conn, jwt: jwt} do
      args = get_post_args()

      response =
        conn
        |> put_req_header("authorization", "bearer #{jwt}")
        |> get_response(args)

      assert %{
               "data" => %{
                 "products" => [%{"id" => _}]
               }
             } = json_response(response, 200)
    end
  end
end
