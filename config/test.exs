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

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason