import Config

config :currency_converter,
  ecto_repos: [CurrencyConverter.Repo],
  generators: [timestamp_type: :utc_datetime]

config :currency_converter, CurrencyConverter.Cache,
  backend: :ets,
  ttl_check_interval: :timer.minutes(30),
  global_ttl: :timer.hours(1)

config :currency_converter, CurrencyConverterWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: CurrencyConverterWeb.ErrorHTML, json: CurrencyConverterWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CurrencyConverter.PubSub,
  live_view: [signing_salt: "EDjig3XO"]

config :esbuild,
  version: "0.17.11",
  currency_converter: [
    args:
      ~w(js/app.ts --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.0",
  currency_converter: [
    args: ~w(
      --config=tailwind.config.ts
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
