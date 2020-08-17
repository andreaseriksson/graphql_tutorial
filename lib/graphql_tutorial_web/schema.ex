defmodule GraphqlTutorialWeb.Schema do
  use Absinthe.Schema

  alias GraphqlTutorialWeb.Schema

  import_types(Schema.UserTypes)
  import_types(Schema.ProductTypes)

  query do
    import_fields(:get_products)
    import_fields(:get_product)
  end

  mutation do
    import_fields(:login_mutation)
    import_fields(:create_user_mutation)

    import_fields(:create_product)
    import_fields(:update_product)
    import_fields(:delete_product)
  end
end
