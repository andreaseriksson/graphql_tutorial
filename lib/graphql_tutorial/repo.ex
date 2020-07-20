defmodule GraphqlTutorial.Repo do
  use Ecto.Repo,
    otp_app: :graphql_tutorial,
    adapter: Ecto.Adapters.Postgres
end
