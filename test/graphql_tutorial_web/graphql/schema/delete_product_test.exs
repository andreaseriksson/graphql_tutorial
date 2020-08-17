defmodule GraphqlTutorialWeb.Schema.DeleteProductTest do
  use GraphqlTutorialWeb.ConnCase, async: false
  import GraphqlTutorial.GraphqlTestHelpers

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  @query """
    mutation ($id: ID!) {
      product: deleteProduct(id: $id) {
        id
        name
      }
    }
  """

  defp get_post_args(args) do
    %{
      query: @query,
      variables: %{
        "id" => args[:id]
      }
    }
  end

  describe "when not logged in" do
    setup [:user_with_invalid_jwt, :with_product]

    test "delete product with invalid credentials", %{conn: conn, product: product} do
      %{id: id} = product
      args = get_post_args(%{id: id})

      response =
        conn
        |> get_response(args)

      assert %{
               "data" => %{"product" => nil},
               "errors" => [
                 %{
                   "message" => "Not Authorized"
                 }
               ]
             } = json_response(response, 200)
    end
  end

  describe "when logged in" do
    setup [:user_with_valid_jwt, :with_product]

    test "delete product with valid credentials", %{
      conn: conn,
      product: product,
    } do
      %{id: id} = product
      args = get_post_args(%{id: id})

      response =
        conn
        |> get_response(args)

      assert %{
               "data" => %{
                 "product" => %{"id" => product_id, "name" => "" <> _}
               }
             } = json_response(response, 200)

      assert product_id == "#{id}"
      assert GraphqlTutorial.Products.list_products() == []
    end

    test "delete product when id is wrong", %{conn: conn} do
      args = get_post_args(%{id: 0})

      response =
        conn
        |> get_response(args)

      assert %{
               "data" => %{
                 "product" => nil
               }
             } = json_response(response, 200)

      assert [_] = GraphqlTutorial.Products.list_products()
    end
  end
end
