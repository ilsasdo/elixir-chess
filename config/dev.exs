import Config

config :chess,
       ChessWeb.Endpoint,
       http: [ip: {127, 0, 0, 1}, port: 4000],
       url: [host: "localhost"],
       debug_errors: true,
       code_reloader: true,
       check_origin: false,
       watchers: [],
       server: true

config :chess, Chess.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "chess_dev_2",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :chess, ecto_repos: [Chess.Repo], event_stores: [
                                           Chess.Infrastructure.EventStore
]

config :chess, Chess.Infrastructure.EventStore,
       serializer: Commanded.Serialization.JsonSerializer,
       username: "postgres",
       password: "postgres",
       database: "chess_eventstore_dev",
       hostname: "localhost"