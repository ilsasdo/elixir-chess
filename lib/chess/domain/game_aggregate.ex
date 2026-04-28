# aggregate
defmodule Chess.Domain.GameAggregate do
  defstruct [:id, board: %Chess.Domain.Board{}]

  alias Chess.Domain.Commands.CreateGame
  alias Chess.Domain.Events.GameCreated

  alias Chess.Domain.Commands.MakeMove
  alias Chess.Domain.Events.MoveMade

  def execute(game_aggregate, %CreateGame{id: id} = cmd) do
    %GameCreated{id: id}
  end

  def apply(game_aggregate, %GameCreated{id: id} = cmd) do
    %{
      game_aggregate
      | board: Chess.Domain.Board.new()
    }
  end

  def execute(%__MODULE__{ board: board } = game_aggregate, %MakeMove{id: id, from: from, to: to, player: player} = cmd) do
    if Chess.Domain.Board.is_valid_move?(board, from, to) do
      %MoveMade{id: id, from: from, to: to, player: player}
    else
      {:error, :invalid_move}
    end
  end

  def apply(%__MODULE{board: board} = game_aggregate, %MoveMade{id: id, from: from, to: to, player: player}) do
    %{game_aggregate | board: Chess.Domain.Board.move(board, from, to)}
  end
end
