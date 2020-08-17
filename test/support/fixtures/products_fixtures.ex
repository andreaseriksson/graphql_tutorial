defmodule GraphqlTutorial.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlTutorial.Products` context.
  """

  alias GraphqlTutorial.Products

  @valid_attrs %{
    description: "some description",
    name: "some name",
    price: 120.5
  }

  def valid_product_attrs, do: @valid_attrs

  def product_fixture(attrs \\ %{}) do
    {:ok, product} = Products.create_product(@valid_attrs)

    product
  end
end
