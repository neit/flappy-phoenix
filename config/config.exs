# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :flappy_phoenix, FlappyPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f+B6npa1IL3GLYaEXZA/N8OXhIP0LQDVh1sj8QF2n/iAKc1sJqScw2SVS6wXW+eS",
  render_errors: [view: FlappyPhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FlappyPhoenix.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "SECRET_SALT"]

config :flappy_phoenix, FlappyPhoenixWeb.Endpoint, instrumenters: [Appsignal.Phoenix.Instrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine],
  eex: Appsignal.Phoenix.Template.EExEngine,
  exs: Appsignal.Phoenix.Template.ExsEngine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
