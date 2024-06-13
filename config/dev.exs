import Config

config :currency_converter, CurrencyConverter.Repo,
  database: "_build/dev/rel/currency_converter/bin/currency_converter_dev.sqlite3"

config :currency_converter, CurrencyConverterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "MM7gtqjtg23SWeeXO3yoFiy9CR0VhLOxX6cHrIMqwgnCiAjRCN7naHSDG56i3TrJ",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:currency_converter, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:currency_converter, ~w(--watch)]}
  ]

config :currency_converter, CurrencyConverterWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/currency_converter_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :currency_converter, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true
