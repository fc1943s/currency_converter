defmodule CurrencyConverterWeb.Router do
  use CurrencyConverterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CurrencyConverterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CurrencyConverterWeb do
    pipe_through :browser

    live "/", ConversionLive, :index
  end

  scope "/api", CurrencyConverterWeb do
    pipe_through :api
    post "/convert", ConversionController, :convert
    get "/transactions/:user_id", ConversionController, :list
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:currency_converter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CurrencyConverterWeb.Telemetry
    end
  end
end
