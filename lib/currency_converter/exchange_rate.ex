defmodule CurrencyConverter.ExchangeRate do
  @moduledoc """
  Fetches exchange rates from an external API and provides conversion functions.
  """

  require Logger

  alias Phoenix.PubSub

  @api_url "http://api.exchangeratesapi.io/latest?access_key=" <>
             System.get_env("LB_EXCHANGERATES_API_KEY", "") <> "&base=EUR"

  @topic :rates_cache

  defp fetch_rates do
    Logger.debug("exchange_rate.fetch_rates")

    case HTTPoison.get(@api_url) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"error" => reason, "success" => false}} ->
            # {:error, :exchangerates_error, reason}
            {:ok, -1}

          {:ok, result} ->
            :ok = ConCache.put(@topic, :rates, result)
            PubSub.broadcast(CurrencyConverter.PubSub, @topic, {:update, result})
            {:ok, result}

          {:error, reason} ->
            {:error, :json_error, reason}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, :http_error, reason}
    end
  end

  def handle_info({:update, new_rates}, state) do
    Logger.debug("exchange_rate.handle_info / new_rates: #{new_rates} / state: #{state}")
    ConCache.put(@topic, :rates, new_rates)
    {:noreply, state}
  end

  def get_rates do
    Logger.debug("exchange_rate.get_rates / cache: #{ConCache.get(@topic, :rates)}")

    case ConCache.get(@topic, :rates) do
      nil -> fetch_rates()
      cached_rates -> {:ok, cached_rates}
    end
  end

  @spec get_rate(any()) ::
          {:ok, any()}
          | {:error, :exchangerates_error | :http_error | :json_error2 | :rate_not_found, any()}
  defp get_rate(to) do
    Logger.debug("exchange_rate.get_rate / to: #{to}")

    with {:ok, %{"rates" => rates}} <- get_rates(),
         {:ok, rate} <- Map.fetch(rates, to) do
      {:ok, rate}
    else
      {:error, error, reason} -> {:error, :rate_not_found, {error, reason}}
      result -> result
    end
  end

  @spec convert(any(), any(), any()) ::
          {:ok, number(), [{:rate, number()}, ...]}
          | {:error, :exchangerates_error | :http_error | :json_error3 | :rate_not_found, any()}
  def convert(from, to, amount) do
    Logger.debug("exchange_rate.convert / from: #{from} / to: #{to} / amount: #{amount}")

    case get_rate(to) do
      {:ok, rate} -> {:ok, amount * rate, rate: rate}
      {:error, error, reason} -> {:error, error, reason}
    end
  end
end
