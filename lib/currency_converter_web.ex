defmodule CurrencyConverterWeb do
  @moduledoc """
  Defines common imports, uses, and aliases for controllers, channels, and other components in the CurrencyConverterWeb module.
  Provides convenient access to static paths, routes, and HTML helpers.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: CurrencyConverterWeb.Layouts]

      import Plug.Conn
      import CurrencyConverterWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {CurrencyConverterWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      import Phoenix.HTML
      import CurrencyConverterWeb.Gettext

      alias Phoenix.LiveView.JS

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: CurrencyConverterWeb.Endpoint,
        router: CurrencyConverterWeb.Router,
        statics: CurrencyConverterWeb.static_paths()
    end
  end

  @spec __using__(atom()) :: any()
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
