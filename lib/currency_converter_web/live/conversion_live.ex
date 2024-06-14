defmodule CurrencyConverterWeb.ConversionLive do
  use CurrencyConverterWeb, :live_view

  alias CurrencyConverter.ExchangeRate
  alias CurrencyConverter.Transactions

  def mount(_params, _session, socket),
    do: {:ok, assign(socket, from: "USD", to: "BRL", amount: 0, result: nil, error: nil)}

  defp create_transaction({from, amount, to, to_amount, rate, socket}) do
    case(
      Transactions.create_conversion(%{
        user_id: 1,
        from_currency: from,
        from_amount: String.to_float(amount),
        to_currency: to,
        rate: rate,
        timestamp: DateTime.utc_now()
      })
    ) do
      {:ok, conversion} ->
        {:noreply,
         assign(socket,
           result: %{
             transaction_id: conversion.id,
             user_id: 1,
             from_currency: from,
             from_amount: amount,
             to_currency: to,
             to_amount: to_amount,
             rate: rate,
             timestamp: conversion.timestamp
           },
           error: nil
         )}

      _ ->
        {:noreply, assign(socket, error: "Failed to create transaction")}
    end
  end

  def handle_event("convert", %{"from" => from, "to" => to, "amount" => amount}, socket) do
    case(ExchangeRate.convert(from, to, String.to_float(amount))) do
      {:ok, to_amount} ->
        case ExchangeRate.fetch_rate(to) do
          {:ok, rate} -> create_transaction({from, amount, to, to_amount, rate, socket})
          _ -> {:noreply, assign(socket, error: "Failed to fetch exchange rate")}
        end

      _ ->
        {:noreply, assign(socket, error: "Conversion failed")}
    end
  end

  def render(assigns),
    do: ~H"""
    <div>
      <form phx-submit="convert">
        <input type="text" name="from" value={@from} placeholder="From currency" />
        <input type="text" name="to" value={@to} placeholder="To currency" />
        <input type="number" name="amount" value={@amount} placeholder="Amount" />
        <button type="submit">Convert</button>
      </form>
      <p>Result: <%= inspect @result %></p>
      <p>Error: <%= @error %></p>
    </div>
    """
end
