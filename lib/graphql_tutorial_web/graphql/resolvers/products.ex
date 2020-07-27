defmodule GraphqlTutorialWeb.Resolvers.Products do
  alias GraphqlTutorial.Products
  alias GraphqlTutorial.Products.Product

  def list_products(_args, _context) do
    {:ok, Products.list_products()}
  end

  def get_product(%{id: id}, _context) do
    {:ok, Products.get_product(id)}
  end

  def create_product(args, %{context: %{current_user: _user}}) do
    case Products.create_product(args) do
      {:ok, %Product{} = product} -> {:ok, product}
      {:error, changeset} -> {:error, inspect(changeset.errors)}
    end
  end

  def create_product(_args, _context), do: {:error, "Not Authorized"}

  def update_product(%{id: id} = params, %{context: %{current_user: _user}}) do
    case Products.get_product(id) do
      nil ->
        {:error, "Product not found"}

      %Product{} = product ->
        case Products.update_product(product, params) do
          {:ok, %Product{} = product} -> {:ok, product}
          {:error, changeset} -> {:error, inspect(changeset.errors)}
        end
    end
  end

  def update_product(_args, _context), do: {:error, "Not Authorized"}

  def delete_product(%{id: id}, %{context: %{current_user: _user}}) do
    case Products.get_product(id) do
      nil -> {:error, "Product not found"}
      %Product{} = product -> Products.delete_product(product)
    end
  end

  def delete_product(_args, _context), do: {:error, "Not Authorized"}
end
