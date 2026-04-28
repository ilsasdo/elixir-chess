defmodule Chess.CommandedApplication do

  use Commanded.Application, otp_app: :chess, event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Chess.Infrastructure.EventStore]

  router Chess.Application.Router
end
