import Config

config :currency_converter, CurrencyConverter.Repo,
  database: "_build/prod/rel/currency_converter/bin/currency_converter.sqlite3"

config :currency_converter, CurrencyConverterWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
