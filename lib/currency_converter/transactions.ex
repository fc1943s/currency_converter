defmodule CurrencyConverter.Transactions do
  @moduledoc """
  Manages currency conversion transactions, including listing conversions by user and creating new conversions.
  """

  import Ecto.Query, warn: false
  alias CurrencyConverter.Repo
  alias CurrencyConverter.Transactions.Conversion

  def list_conversions_by_user(user_id),
    do: Repo.all(from c in Conversion, where: c.user_id == ^user_id)

  def list_conversions, do: Repo.all(Conversion)
  def get_conversion!(id), do: Repo.get!(Conversion, id)

  def create_conversion(attrs \\ %{}),
    do: %Conversion{} |> Conversion.changeset(attrs) |> Repo.insert()

  def update_conversion(%Conversion{} = conversion, attrs),
    do:
      conversion
      |> Conversion.changeset(attrs)
      |> Repo.update()

  def delete_conversion(%Conversion{} = conversion), do: Repo.delete(conversion)

  def change_conversion(%Conversion{} = conversion, attrs \\ %{}),
    do: Conversion.changeset(conversion, attrs)
end
