defmodule Chess do
  @moduledoc """
  Documentation for `Chess`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Chess.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  constructs a new chessboard
  """
  def new_board do
    pieces_rank = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook]
    pawn_rank_builder = fn color -> (1..8) |> Enum.map(fn i -> {i, {:pawn, color}} end) |> Map.new end
    piece_rank_builder = fn color -> (1..8) |> Enum.map(fn i -> {i, {Enum.at(pieces_rank, i - 1), color}} end) |> Map.new end
    empty_rank_builder = fn -> (1..8) |> Enum.map(fn i -> {i, {:empty, :empty}} end) |> Map.new end
    %{
      8 => piece_rank_builder.(:black),
      7 => pawn_rank_builder.(:black),
      6 => empty_rank_builder.(),
      5 => empty_rank_builder.(),
      4 => empty_rank_builder.(),
      3 => empty_rank_builder.(),
      2 => pawn_rank_builder.(:white),
      1 => piece_rank_builder.(:white)
    }
  end

  def list_moves(chessboard, {file, rank}) do
    list_moves(chessboard, {file, rank}, chessboard[rank][file])
  end

  def list_moves(chessboard, {file, rank}, {:pawn, :white}) do
    moves = []
    # the pawn can go forward one step when free:
    forward_square = get_square(chessboard, {file, rank + 1})
    case forward_square do
      {:empty, :empty} ->
        moves = [ {file, rank + 1} | moves]
    end

    # the pawn can take on upper left/right

    # if the pawn is at starting position, it can go two step forward
  end

  def flip_board(chessboard) do

  end

  def get_square(chessboard, {file, rank}) do
    f = case file do
      :a -> 1
      :b -> 2
      :c -> 3
      :d -> 4
      :e -> 5
      :f -> 6
      :g -> 7
      :h -> 8
      _ -> file
    end
    {:just, chessboard[rank][f]}
  end

end
