defmodule Chess.Infrastructure.Games do

  def list_games() do
    [%{:id => 1}, %{:id => 2}, %{:id => 3}]
  end

  def get_game!(id) do
    Chess.Domain.Board.new()
  end

  def make_move(id, from, to) do
    board = Chess.Domain.Board.new()
    Chess.Domain.Board.move(board, from, to)
  end
end
