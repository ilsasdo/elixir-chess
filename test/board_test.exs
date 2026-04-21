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

  test "get available moves for king" do
    board = Board.new()
    assert Board.get_moves(board.squares, "e4") == []

    squares = Board.move(board.squares, "e1", "e4")
    assert (Board.get_moves(squares, "e4") |> Enum.sort) == ([
             "e5",
             "e3",
             "f5",
             "f4",
             "f3",
             "d5",
             "d4",
             "d3"
           ] |> Enum.sort)
  end

  test "get available moves for rook" do
    board = Board.new()
    assert Board.get_moves(board.squares, "a1") == []

    squares = Board.move(board.squares, "a1", "e4")

    assert Board.get_moves(squares, "e4") |> Enum.sort() ==
             ["a4", "b4", "c4", "d4", "f4", "g4", "h4", "e3", "e5", "e6", "e7"] |> Enum.sort()
  end

  test "get available moves for bishop" do
    board = Board.new()
    assert Board.get_moves(board.squares, "f1") == []

    squares = Board.move(board.squares, "f1", "e4")

    assert Board.get_moves(squares, "e4") |> Enum.sort() ==
             ["d3", "f5", "g6", "h7", "f3", "d5", "c6", "b7"] |> Enum.sort()
  end

  test "get available moves for queen" do
    board = Board.new()
    assert Board.get_moves(board.squares, "d1") == []

    squares = Board.move(board.squares, "d1", "e4")

    assert (Board.get_moves(squares, "e4") |> Enum.sort()) == ([
        "d3",
        "f5",
        "g6",
        "h7",
        "f3",
        "d5",
        "c6",
        "b7",
        "a4",
        "b4",
        "c4",
        "d4",
        "f4",
        "g4",
        "h4",
        "e3",
        "e5",
        "e6",
        "e7"
      ]
      |> Enum.sort())
  end

  test "verify available moves for knight" do
    board = Board.new()
    assert Board.get_moves(board.squares, "b1") |> Enum.sort() == ["a3", "c3"]
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
end
