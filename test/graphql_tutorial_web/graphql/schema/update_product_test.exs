defmodule GraphqlTutorialWeb.Schema.UpdateProductTest do
  use GraphqlTutorialWeb.ConnCase, async: false
  import GraphqlTutorial.GraphqlTestHelpers

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  @query """
    mutation (
      $id: ID!,
      $name: String,
    ) {
      product: updateProduct(
        id: $id,
        name: $name,
      ) {
        id
        name
      }
    }
  """

  @valid_attrs %{
    name: "some name"
  }

  defp get_post_args(args) do
    %{
      query: @query,
      variables: %{
        "id" => "#{args[:id]}",
        "name" => args[:name]
      }
    }
  end

  describe "when not logged in" do
    setup [:user_with_invalid_jwt, :with_product]

    test "update product with invalid credentials", %{conn: conn, product: product} do
      attrs = Map.put(@valid_attrs, :id, product.id)
      args = get_post_args(attrs)

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

    test "update product with valid attributes", %{conn: conn, product: product} do
      attrs = Map.put(@valid_attrs, :id, product.id)
      args = get_post_args(attrs)

      response =
        conn
        |> get_response(args)

      assert %{
               "data" => %{
                 "product" => %{
                   "name" => "some name",
                   "id" => product_id
                 }
               }
             } = json_response(response, 200)

      assert product_id == "#{product.id}"
    end

    test "update product when id is wrong", %{conn: conn} do
      attrs = Map.put(@valid_attrs, :id, 0)
      args = get_post_args(attrs)

      response =
        conn
        |> get_response(args)

      assert %{
               "data" => %{
                 "product" => nil
               }
             } = json_response(response, 200)
    end
  end
end
