defmodule CurrencyConverterWeb.TransactionsController do
  use CurrencyConverterWeb, :controller

  def home(conn, _params), do: render(conn, :home, layout: false)
end
