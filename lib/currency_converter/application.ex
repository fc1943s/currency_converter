defmodule CurrencyConverter.Application do
  @moduledoc """
  Starts and supervises the application processes for CurrencyConverter.
  Handles configuration changes dynamically for the web endpoint.
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CurrencyConverterWeb.Telemetry,
      CurrencyConverter.Repo,
      {DNSCluster,
       query: Application.get_env(:currency_converter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CurrencyConverter.PubSub},
      CurrencyConverterWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CurrencyConverter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CurrencyConverterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
