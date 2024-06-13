import Config

config :currency_converter, CurrencyConverterWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info
