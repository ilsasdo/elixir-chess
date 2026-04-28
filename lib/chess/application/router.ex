defmodule Chess.Application.Router do
  use Commanded.Commands.Router

  alias Chess.Domain.GameAggregate
  alias Chess.Domain.Commands.CreateGame
  alias Chess.Domain.Commands.MakeMove

  identify GameAggregate, by: :id

  dispatch CreateGame, to: GameAggregate
  dispatch MakeMove, to: GameAggregate
end
