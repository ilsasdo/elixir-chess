defmodule ChessTest do
  use ExUnit.Case
  doctest Board

  test "should init a new chessboard" do
    assert Board.new().squares |> map_size == 64
  end

  test "get_square should resolve the piece / empty" do
    board = Board.new()
    assert Board.get_square(board.squares, 0, 0) == {:rook, :white}
    assert Board.get_square(board.squares, 4, 4) == :empty
  end

  test "get_square on invalid fields should return empty" do
    board = Board.new()
    assert Board.get_square(board.squares, 10, 10) == :empty
  end

  test "get_square north of a square" do
    board = Board.new()
    assert Board.get_square(board.squares, Board.pos({0, 0}, :n)) == {:pawn, :white}
  end

  test "get_square east of a square" do
    board = Board.new()
    assert Board.get_square(board.squares, Board.pos({0, 0}, :e)) == {:knight, :white}
  end

  test "get available moves for pawn" do
    board = Board.new()
    assert Board.get_moves(board.squares, {0, 1}) == [{0, 2}, {0, 3}]
    assert Board.get_moves(board.squares, "a2") == ["a3", "a4"]
    assert Board.get_moves(board.squares, "e7") == ["e6", "e5"]
  end

  test "verify available moves for knight" do
    board = Board.new()
    assert Board.get_moves(board.squares, "b1") |> Enum.sort == ["a3", "c3"]
  end

  test "verify move" do
    {x, y} = Board.pos({0, 0}, :n)
    assert x == 0
    assert y == 1
  end

  test "move a piece" do
    board = Board.new()
    moved = board.squares |> Board.move({0, 1}, {0, 2})

    assert moved[{0, 1}] == :empty
    assert moved[{0, 2}] == {:pawn, :white}
  end


  #  test "all ranks must be of size 8" do
  #    board = Board.new_board()
  #    assert board[1] |> map_size == 8
  #    assert board[2] |> map_size == 8
  #    assert board[3] |> map_size == 8
  #    assert board[4] |> map_size == 8
  #    assert board[5] |> map_size == 8
  #    assert board[6] |> map_size == 8
  #    assert board[7] |> map_size == 8
  #    assert board[8] |> map_size == 8
  #  end
  #
  #  test "all ranks must be of size 8 with map accessor" do
  #    board = Board.new_board()
  #    count = board
  #      |> Map.keys() # it's not elm: add ()
  #      |> Enum.map(fn k -> board[k] end) #it's not elm: add ()
  #      |> Enum.map(fn k -> map_size(k) end) #it's not elm: add ()
  #      |> Enum.filter(fn size -> size == 8 end)
  #      |> length()
  #
  #    assert count == 8
  #  end
  #
  #  test "accessing chessboard" do
  #    board = Board.new_board()
  #    assert Board.get_square(board, {:a, 1}) == {:rook, :white}
  #    assert Board.get_square(board, {:a, 2}) == {:pawn, :white}
  #    assert Board.get_square(board, {:b, 8}) == {:knight, :black}
  #    assert Board.get_square(board, {:b, 7}) == {:pawn, :black}
  #  end
end
