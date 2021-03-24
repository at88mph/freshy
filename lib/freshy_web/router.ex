defmodule FreshyWeb.Router do
  use FreshyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Freshy.AuthPlug
  end

  scope "/", FreshyWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/freshy/auth", FreshyWeb do
    pipe_through :browser

    get "/uri", AuthController, :authorization_uri
    get "/callback", AuthController, :callback
    get "/:provider", AuthController, :authenticate
  end

  scope "/freshy", FreshyWeb do
    pipe_through [:browser, :authenticated]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FreshyWeb do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: FreshyWeb.Telemetry
    end
  end
end
