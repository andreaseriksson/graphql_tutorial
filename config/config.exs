# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :graphql_tutorial,
  ecto_repos: [GraphqlTutorial.Repo]

# Configures the endpoint
config :graphql_tutorial, GraphqlTutorialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ugn/5/X2oz5M34vA+Rk6o5eEBVMsOpynJLRHzLqvbdqinRZe/n8dGbSgYcZ3LW+U",
  render_errors: [view: GraphqlTutorialWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GraphqlTutorial.PubSub,
  live_view: [signing_salt: "VX8/LINc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :graphql_tutorial, GraphqlTutorial.Guardian,
   issuer: "graphql_tutorial",
   secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
   ttl: {30, :days}

config :graphql_tutorial, GraphqlTutorialWeb.AuthAccessPipeline,
   module: GraphqlTutorial.Guardian,
   error_handler: GraphqlTutorialWeb.AuthErrorHandler

config :waffle,
  storage: Waffle.Storage.S3, # or Waffle.Storage.Local
  bucket: System.get_env("AWS_BUCKET_NAME") # if using S3

# If using S3:
config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

config :graphql_tutorial, GraphqlTutorial.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: "my_api_key"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
