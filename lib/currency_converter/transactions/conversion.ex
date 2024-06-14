defmodule CurrencyConverter.Transactions.Conversion do
  @moduledoc """
  Represents a currency conversion transaction.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "conversions" do
    field :user_id, :integer
    field :from_currency, :string
    field :from_amount, :float
    field :to_currency, :string
    field :rate, :float
    field :timestamp, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversion, attrs) do
    conversion
    |> cast(attrs, [
      :user_id,
      :from_currency,
      :from_amount,
      :to_currency,
      :rate,
      :timestamp
    ])
    |> validate_required([
      :user_id,
      :from_currency,
      :from_amount,
      :to_currency,
      :rate,
      :timestamp
    ])
  end
end
