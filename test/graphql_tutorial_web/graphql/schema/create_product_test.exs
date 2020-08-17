defmodule GraphqlTutorialWeb.Schema.CreateProductTest do
  use GraphqlTutorialWeb.ConnCase, async: false
  import GraphqlTutorial.GraphqlTestHelpers
  import GraphqlTutorial.ProductsFixtures

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  @query """
    mutation (
      $name: String!,
      $description: String!,
      $price: Float!,
    ) {
      product: createProduct(
        name: $name,
        description: $description,
        price: $price,
      ) {
        name
        description
        price
      }
    }
  """

  @valid_attrs valid_product_attrs()

  @invalid_attrs %{
    name: nil
  }

  defp get_post_args(args) do
    %{
      query: @query,
      variables: %{
        "name" => args[:name],
        "description" => args[:description],
        "price" => args[:price]
      }
    }
  end

  describe "when not logged in" do
    test "create product with invalid credentials", %{conn: conn} do
      args = get_post_args(@valid_attrs)

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
    setup [:user_with_valid_jwt]

    test "create product with valid attributes", %{conn: conn} do
      args = get_post_args(@valid_attrs)

      response =
        conn
        |> get_response(args)

      assert %{
               "data" => %{
                 "product" => %{
                   "name" => "some name"
                 }
               }
             } = json_response(response, 200)

      assert [_] = GraphqlTutorial.Products.list_products()
    end

    test "create product with invalid attributes", %{conn: conn} do
      args = get_post_args(@invalid_attrs)

      response =
        conn
        |> get_response(args)

      assert %{
               "errors" => [
                 %{
                   "locations" => [_],
                   "message" => "Argument \"name\" has invalid value $name."
                 }
                 | _
               ]
             } = json_response(response, 200)

      assert [] = GraphqlTutorial.Products.list_products()
    end
  end
end
