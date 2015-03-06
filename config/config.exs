# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :mustang, Mustang.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7Rq4kziOWAjvcP043VCm0XRUI+BoAOoBZrVDXLaaw3Ideg3x+dml9tZxFxvF59cU",
  debug_errors: false,
  pubsub: [adapter: Phoenix.PubSub.PG2]

# In your config/config.exs file
config :mustang, Mustang.Repo,
  database: "mayhem_development",
  username: "sa",
  password: "RakuRaku1",
  hostname: "213.239.208.26"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
