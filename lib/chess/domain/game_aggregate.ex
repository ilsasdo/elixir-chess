# aggregate
defmodule Chess.Domain.GameAggregate do
  defstruct [:id, board: %Chess.Domain.Board{}]

  alias Chess.Domain.Commands.CreateGame
  alias Chess.Domain.Events.GameCreated

  alias Chess.Domain.Commands.MakeMove
  alias Chess.Domain.Events.MoveMade

  def execute(game_aggregate, %CreateGame{id: id} = cmd) do
    board = Chess.Domain.Board.new()
    fen = Chess.Domain.Board.to_fen(board)
    %GameCreated{id: id, fen: fen }
  end

  def apply(game_aggregate, %GameCreated{id: id} = cmd) do
    %{
      game_aggregate
      | board: Chess.Domain.Board.new()
    }
  end

  def execute(%__MODULE__{ board: board } = game_aggregate, %MakeMove{id: id, from: from, to: to, player: player} = cmd) do
    if Chess.Domain.Board.is_valid_move?(board, from, to) do
      fen = Chess.Domain.Board.move(board, from, to) |> Chess.Domain.Board.to_fen()
      %MoveMade{id: id, from: from, to: to, player: player, fen: fen}
    else
      {:error, :invalid_move}
    end
  end

  def apply(%__MODULE{board: board} = game_aggregate, %MoveMade{id: id, from: from, to: to, player: player, fen: fen}) do
    %{game_aggregate | board: Chess.Domain.Board.from_fen(fen)}
  end
end
