defmodule GraphqlTutorialWeb.Router do
  use GraphqlTutorialWeb, :router

  import GraphqlTutorialWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug GraphqlTutorialWeb.Context
  end

  pipeline :api_authenticated do
    plug GraphqlTutorialWeb.AuthAccessPipeline
  end

  # Other scopes may use custom stacks.
  scope "/api", GraphqlTutorialWeb.Api, as: :api do
    pipe_through :api

    post "/sign_in", SessionController, :create
    resources "/products", ProductController, only: [:index, :show]
  end

  ## Authentication api routes
  scope "/api", GraphqlTutorialWeb.Api, as: :api do
    pipe_through :api_authenticated

    resources "/products", ProductController, except: [:index, :show]
  end

 # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: GraphqlTutorialWeb.Schema
  end

# Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: GraphqlTutorialWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", GraphqlTutorialWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :put_session_layout]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/login", UserSessionController, :new
    post "/users/login", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", GraphqlTutorialWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/products", ProductController, except: [:index, :show]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
    put "/users/settings/update_avatar", UserSettingsController, :update_avatar
  end

  scope "/", GraphqlTutorialWeb do
    pipe_through [:browser]

    delete "/users/logout", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm

    resources "/products", ProductController, only: [:index, :show]
    get "/", PageController, :index
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: GraphqlTutorialWeb.Schema
  end
end
