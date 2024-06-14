defmodule CurrencyConverter.TransactionsTest do
  @moduledoc """
  Tests for CurrencyConverter.Transactions module.
  """

  use CurrencyConverter.DataCase

  alias CurrencyConverter.Transactions

  describe "conversions" do
    alias CurrencyConverter.Transactions.Conversion

    import CurrencyConverter.TransactionsFixtures

    @invalid_attrs %{
      user_id: nil,
      from_currency: nil,
      from_amount: nil,
      to_currency: nil,
      rate: nil,
      timestamp: nil
    }

    test "list_conversions/0 returns all conversions" do
      conversion = conversion_fixture()
      assert Transactions.list_conversions() == [conversion]
    end

    test "get_conversion!/1 returns the conversion with given id" do
      conversion = conversion_fixture()
      assert Transactions.get_conversion!(conversion.id) == conversion
    end

    test "create_conversion/1 with valid data creates a conversion" do
      valid_attrs = %{
        user_id: 42,
        from_currency: "some from_currency",
        from_amount: 120.5,
        to_currency: "some to_currency",
        rate: 120.5,
        timestamp: ~U[2024-06-13 22:02:00Z]
      }

      assert {:ok, %Conversion{} = conversion} = Transactions.create_conversion(valid_attrs)
      assert conversion.user_id == 42
      assert conversion.from_currency == "some from_currency"
      assert conversion.from_amount == 120.5
      assert conversion.to_currency == "some to_currency"
      assert conversion.rate == 120.5
      assert conversion.timestamp == ~U[2024-06-13 22:02:00Z]
    end

    test "create_conversion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_conversion(@invalid_attrs)
    end

    test "update_conversion/2 with valid data updates the conversion" do
      conversion = conversion_fixture()

      update_attrs = %{
        user_id: 43,
        from_currency: "some updated from_currency",
        from_amount: 456.7,
        to_currency: "some updated to_currency",
        rate: 456.7,
        timestamp: ~U[2024-06-14 22:02:00Z]
      }

      assert {:ok, %Conversion{} = conversion} =
               Transactions.update_conversion(conversion, update_attrs)

      assert conversion.user_id == 43
      assert conversion.from_currency == "some updated from_currency"
      assert conversion.from_amount == 456.7
      assert conversion.to_currency == "some updated to_currency"
      assert conversion.rate == 456.7
      assert conversion.timestamp == ~U[2024-06-14 22:02:00Z]
    end

    test "update_conversion/2 with invalid data returns error changeset" do
      conversion = conversion_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_conversion(conversion, @invalid_attrs)

      assert conversion == Transactions.get_conversion!(conversion.id)
    end

    test "delete_conversion/1 deletes the conversion" do
      conversion = conversion_fixture()
      assert {:ok, %Conversion{}} = Transactions.delete_conversion(conversion)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_conversion!(conversion.id) end
    end

    test "change_conversion/1 returns a conversion changeset" do
      conversion = conversion_fixture()
      assert %Ecto.Changeset{} = Transactions.change_conversion(conversion)
    end
  end
end
