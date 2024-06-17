defmodule CurrencyConverterWeb.ConversionController do
  require Logger

  use CurrencyConverterWeb, :controller

  alias CurrencyConverter.Transactions
  alias CurrencyConverter.ExchangeRate

  def convert(conn, %{"user_id" => user_id, "from" => from, "to" => to, "amount" => amount}) do
    Logger.debug("conversion_controller.convert / user_id: #{user_id} / from: #{from} / to: #{to} / amount: #{amount}")
    with {:ok, to_amount, rate: rate} <- ExchangeRate.convert(from, to, String.to_float(amount)),
         {:ok, conversion} <-
           Transactions.create_conversion(%{
             user_id: user_id,
             from_currency: from,
             from_amount: String.to_float(amount),
             to_currency: to,
             rate: rate,
             timestamp: DateTime.utc_now()
           }) do
      json(conn, %{
        transaction_id: conversion.id,
        user_id: user_id,
        from_currency: from,
        from_amount: amount,
        to_currency: to,
        to_amount: to_amount,
        rate: rate,
        timestamp: conversion.timestamp
      })
    else
      _ -> send_resp(conn, 400, "Conversion failed")
    end
  end

  def list(conn, %{"user_id" => user_id}) do
    Logger.debug("conversion_controller.list / user_id: #{user_id}")
    transactions = Transactions.list_conversions_by_user(user_id)
    json(conn, transactions)
  end
end
