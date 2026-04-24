defmodule Chess.Infrastructure.Games do
  def list_games() do
    Chess.Repo.all(Chess.Infrastructure.Schema.Game) |> Enum.map(&to_domain_game(&1))
  end

  def create() do
    board = Chess.Domain.Board.new()
    fen_board = Chess.Domain.Board.to_fen(board)

    {result, inserted_game} = %Chess.Infrastructure.Schema.Game{:fen => fen_board}
    |> Chess.Repo.insert()

    to_domain_game(inserted_game)
  end

  def get_game!(id) do
    Chess.Domain.Board.new()
  end

  def make_move(id, from, to) do
    board = Chess.Domain.Board.new()
    Chess.Domain.Board.move(board, from, to)
  end

  defp to_domain_game(db_game) do
    domain_game = Chess.Domain.Board.from_fen(db_game.fen)
    %{domain_game | id: db_game.id}
  end
end
