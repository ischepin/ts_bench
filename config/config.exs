# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ts_bench,
  ecto_repos: [TsBench.Repo, TsBench.CRepo]

# Configures the endpoint
config :ts_bench, TsBenchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TzOUYJg24Ozm8Llv/ndn6ykegeOUjqd5hlIrKu1fvQuefrHi3Ebw5Ofycf/FJSVk",
  render_errors: [view: TsBenchWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TsBench.PubSub,
  live_view: [signing_salt: "KvFLX5Xg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
