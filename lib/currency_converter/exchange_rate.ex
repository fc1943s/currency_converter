defmodule CurrencyConverter.ExchangeRate do
  @moduledoc """
  Fetches exchange rates from an external API and provides conversion functions.
  """

  @api_url "http://api.exchangeratesapi.io/latest?base=EUR"

  def fetch_rates do
    HTTPoison.get(@api_url)
    |> case do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, Jason.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  def convert(_from, to, amount) do
    with {:ok, %{"rates" => rates}} <- fetch_rates(),
         {:ok, rate} <- Map.fetch(rates, to) do
      {:ok, amount * rate}
    else
      _ -> {:error, :conversion_failed}
    end
  end

  def fetch_rate(to) do
    with {:ok, %{"rates" => rates}} <- fetch_rates(),
         {:ok, rate} <- Map.fetch(rates, to) do
      {:ok, rate}
    else
      _ -> {:error, :rate_not_found}
    end
  end
end
