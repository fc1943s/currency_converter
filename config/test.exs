import Config

config :currency_converter, CurrencyConverter.Repo,
  database: "_build/dev/rel/currency_converter/bin/currency_converter_test#{System.get_env("MIX_TEST_PARTITION")}.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox

config :currency_converter, CurrencyConverterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WWVkmFQ5jHY+Mlxb/i9Bx0EuwpBEgygeMsASUbgaiDNyCdzhbPBBnGc0hQ7Whm2d",
  server: false

config :logger, level: :debug

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
