defmodule CurrencyConverter.Repo.Migrations.CreateConversions do
  use Ecto.Migration

  def change do
    create table(:conversions) do
      add :user_id, :integer
      add :from_currency, :string
      add :from_amount, :float
      add :to_currency, :string
      add :rate, :float
      add :timestamp, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
