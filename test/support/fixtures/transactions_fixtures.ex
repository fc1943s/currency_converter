defmodule CurrencyConverter.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CurrencyConverter.Transactions` context.
  """

  def conversion_fixture(attrs \\ %{}) do
    {:ok, conversion} =
      attrs
      |> Enum.into(%{
        user_id: 42,
        from_currency: "some from_currency",
        from_amount: 120.5,
        to_currency: "some to_currency",
        rate: 120.5,
        timestamp: ~U[2024-06-13 22:02:00Z]
      })
      |> CurrencyConverter.Transactions.create_conversion()

    conversion
  end
end
