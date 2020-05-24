# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :scraper, ScraperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DHNQKveDdNuwtK333LyiwTvBdF3GPFG7woHM88DCFXU90xU3UBm8wtbFMkzcnIpN",
  render_errors: [view: ScraperWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Scraper.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "SR4iGdGp"],
  analysis_server: "url"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :new_relic_agent,
  app_name: "Scraper Elixir App",
  license_key: "eu01xxa31792eae8c04ac5416a05c87a1d9eNRAL"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
