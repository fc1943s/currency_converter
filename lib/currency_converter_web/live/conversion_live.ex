defmodule CurrencyConverterWeb.ConversionLive do
  require Logger

  use CurrencyConverterWeb, :live_view

  alias CurrencyConverter.ExchangeRate
  alias CurrencyConverter.Transactions

  @spec mount(any(), any(), any()) :: {:ok, any()}
  def mount(params, session, socket) do
    Logger.debug("conversion_live.mount / params: #{params |> inspect} / session: #{session |> inspect} / socket: #{socket |> inspect}")

    {:ok, assign(socket, from: "USD", to: "BRL", amount: 0, result: nil, error: nil, reason: nil)}
  end

  defp create_transaction(
         from: from,
         amount: amount,
         to: to,
         to_amount: to_amount,
         rate: rate,
         socket: socket
       ) do
    Logger.debug("conversion_live.create_transaction / from: #{from} / amount: #{amount} / to: #{to} / to_amount: #{to_amount} / rate: #{rate} / socket: #{socket |> inspect}")

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
           error: nil,
           reason: nil
         )}

      error ->
        {:noreply, assign(socket, error: error, reason: nil)}
    end
  end

  defp parse_float(amount) do
    case Float.parse(amount) do
      {amount, _} -> {:ok, amount}
      error -> {:error, :invalid_format, error}
    end
  end

  @spec handle_event(<<_::56>>, map(), any()) :: {:noreply, any()}
  def handle_event("convert", %{"from" => from, "to" => to, "amount" => amount}, socket) do
    Logger.debug("conversion_live.handle_event / from: #{from} / amount: #{amount} / to: #{to} / amount: #{amount} / socket: #{socket |> inspect}")

    case parse_float(amount) do
      {:ok, amount_float} ->
        case ExchangeRate.convert(from, to, amount_float) do
          {:ok, to_amount, rate: rate} ->
            create_transaction(
              from: from,
              amount: amount,
              to: to,
              to_amount: to_amount,
              rate: rate,
              socket: socket
            )

          {:error, error, reason} ->
            {:noreply, assign(socket, error: error, reason: reason)}
        end

      {:error, error, reason} ->
        {:noreply, assign(socket, error: error, reason: reason)}
    end
  end

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    Logger.debug("conversion_live.render / assigns: #{assigns |> inspect}")

    ~H"""
    <div>
      <form phx-submit="convert">
        <input type="text" name="from" value={@from} placeholder="From currency" />
        <input type="text" name="to" value={@to} placeholder="To currency" />
        <input type="number" name="amount" value={@amount} step="0.01" placeholder="Amount" />
        <button type="submit">Convert</button>
      </form>
      <p>Result: <%= inspect(@result) %></p>
      <p>Error: <%= inspect(@error) %></p>
      <p>Reason: <%= inspect(@reason) %></p>
    </div>
    """
  end
end
