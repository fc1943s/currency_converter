import Config

if System.get_env("PHX_SERVER") do
  config :currency_converter, CurrencyConverterWeb.Endpoint, server: true
end

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  port = String.to_integer(System.get_env("PORT") || "4000")

  config :currency_converter, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :currency_converter, CurrencyConverterWeb.Endpoint,
    url: [port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end