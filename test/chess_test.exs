defmodule ChessTest do
  use ExUnit.Case
  doctest Chess

  test "greets the world" do
    assert Chess.hello() == :world
  end

  test "should init a new chessboard" do
    assert Chess.new_board() |> map_size == 8
  end

  test "all ranks must be of size 8" do
    board = Chess.new_board()
    assert board[1] |> map_size == 8
    assert board[2] |> map_size == 8
    assert board[3] |> map_size == 8
    assert board[4] |> map_size == 8
    assert board[5] |> map_size == 8
    assert board[6] |> map_size == 8
    assert board[7] |> map_size == 8
    assert board[8] |> map_size == 8
  end

  test "all ranks must be of size 8 with map accessor" do
    board = Chess.new_board()
    count = board
      |> Map.keys() # it's not elm: add ()
      |> Enum.map(fn k -> board[k] end) #it's not elm: add ()
      |> Enum.filter(fn k -> map_size(k) == 8 end) # add () without any space!!
      |> length()

    assert count == 8
  end

  test "accessing chessboard" do
    board = Chess.new_board()
    assert Chess.get_square(board, {:a, 1}) == {:rook, :white}
    assert Chess.get_square(board, {:a, 2}) == {:pawn, :white}
    assert Chess.get_square(board, {:b, 8}) == {:knight, :black}
    assert Chess.get_square(board, {:b, 7}) == {:pawn, :black}
  end

end
