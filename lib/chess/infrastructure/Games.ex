defmodule Chess.Infrastructure.Games do
  def list_games() do
    Chess.Repo.all(Chess.Infrastructure.Schema.Game)
  end

  def create() do
    board = Chess.Domain.Board.new()
    fen_board = Chess.Domain.Board.to_fen(board)

    %Chess.Infrastructure.Schema.Game{:fen => fen_board}
    |> Chess.Repo.insert()
    |> Chess.Domain.Board.from_fen()
  end

  def get_game!(id) do
    Chess.Domain.Board.new()
  end

  def make_move(id, from, to) do
    board = Chess.Domain.Board.new()
    Chess.Domain.Board.move(board, from, to)
  end
end
