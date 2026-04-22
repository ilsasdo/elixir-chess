defmodule Chess.Domain.BoardTest do
  use ExUnit.Case
  doctest Chess.Domain.Board

  test "should init a new chessboard" do
    assert Chess.Domain.Board.new().squares |> map_size == 64
  end

  test "get_square should resolve the piece / empty" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_square(board, 0, 0) == {:rook, :white}
    assert Chess.Domain.Board.get_square(board, 4, 4) == :empty
  end

  test "get_square on invalid fields should return empty" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_square(board, 10, 10) == :empty
  end

  test "get_square north of a square" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_square(board, Chess.Domain.Board.pos({0, 0}, :n)) == {:pawn, :white}
  end

  test "get_square east of a square" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_square(board, Chess.Domain.Board.pos({0, 0}, :e)) == {:knight, :white}
  end

  test "get available moves for pawn" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_moves(board, {0, 1}) == [{0, 2}, {0, 3}]
    assert Chess.Domain.Board.get_moves(board, "a2") == ["a3", "a4"]
    assert Chess.Domain.Board.get_moves(board, "e7") == ["e6", "e5"]
  end

  test "get available moves for king" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_moves(board, "e4") == []

    updatedBoard = Chess.Domain.Board.move(board, "e1", "e4")
    assert (Chess.Domain.Board.get_moves(updatedBoard, "e4") |> Enum.sort) == ([
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
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_moves(board, "a1") == []

    updatedBoard = Chess.Domain.Board.move(board, "a1", "e4")

    assert Chess.Domain.Board.get_moves(updatedBoard, "e4") |> Enum.sort() ==
             ["a4", "b4", "c4", "d4", "f4", "g4", "h4", "e3", "e5", "e6", "e7"] |> Enum.sort()
  end

  test "get available moves for bishop" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_moves(board, "f1") == []

    updatedBoard = Chess.Domain.Board.move(board, "f1", "e4")

    assert Chess.Domain.Board.get_moves(updatedBoard, "e4") |> Enum.sort() ==
             ["d3", "f5", "g6", "h7", "f3", "d5", "c6", "b7"] |> Enum.sort()
  end

  test "get available moves for queen" do
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_moves(board, "d1") == []

    updatedBoard = Chess.Domain.Board.move(board, "d1", "e4")
    assert (Chess.Domain.Board.get_moves(updatedBoard, "e4") |> Enum.sort()) == ([
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
    board = Chess.Domain.Board.new()
    assert Chess.Domain.Board.get_moves(board, "b1") |> Enum.sort() == ["a3", "c3"]
  end

  test "verify move" do
    {x, y} = Chess.Domain.Board.pos({0, 0}, :n)
    assert x == 0
    assert y == 1
  end

  test "move a piece" do
    board = Chess.Domain.Board.new() |> Chess.Domain.Board.move({0, 1}, {0, 2})

    assert Chess.Domain.Board.get_square(board, {0, 1}) == :empty
    assert Chess.Domain.Board.get_square(board, {0, 2}) == {:pawn, :white}
  end
end
