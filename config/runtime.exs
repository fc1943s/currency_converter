import Config

if System.get_env("PHX_SERVER") do
  config :currency_converter, CurrencyConverterWeb.Endpoint, server: true
end

if config_env() == :prod do
  config :currency_converter, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :currency_converter, CurrencyConverterWeb.Endpoint,
    url: [host: System.get_env("PHX_HOST") || "localhost", port: 8080, scheme: "http"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "8080")
    ],
    secret_key_base:
      System.get_env("SECRET_KEY_BASE") ||
        raise("""
        environment variable SECRET_KEY_BASE is missing.
        You can generate one by calling: mix phx.gen.secret
        """)
end
