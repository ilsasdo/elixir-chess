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
    game = Chess.Repo.get(Chess.Infrastructure.Schema.Game, id)
    to_domain_game(game)
  end

  def make_move(id, from, to) do
    db_game = Chess.Repo.get(Chess.Infrastructure.Schema.Game, id)

    domain_game = db_game
    |> to_domain_game()
    |> Chess.Domain.Board.move(from, to)

    fen = Chess.Domain.Board.to_fen(domain_game)

    db_game
    |> Chess.Infrastructure.Schema.Game.changeset(%{fen: fen})
    |> Chess.Repo.update()

    domain_game
  end

  defp to_domain_game(db_game) do
    domain_game = Chess.Domain.Board.from_fen(db_game.fen)
    %{domain_game | id: db_game.id}
  end

  defp to_db_game(domain_game) do
    fen = Chess.Domain.Board.to_fen(domain_game)
    %Chess.Infrastructure.Schema.Game{:id => domain_game.id, :fen => fen}
  end
end
