import Config

config :chess,
       ChessWeb.Endpoint,
       http: [ip: {127, 0, 0, 1}, port: 4000],
       url: [host: "localhost"],
       server: true,
       render_errors: [formats: [html: ChessWeb.ErrorHTML]]

config :chess, ecto_repos: [Chess.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
