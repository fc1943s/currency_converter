defmodule CurrencyConverterWeb.PageController do
  use CurrencyConverterWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
