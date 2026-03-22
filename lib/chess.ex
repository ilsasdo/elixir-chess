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
    %{
      8 => %{:a => {:rook, :black}, :b => {:knight, :black}, :c => {:bishop, :black}, :d => {:queen, :black}, :e => {:king, :black}, :f => {:bishop, :black}, :g => {:knight, :black}, :h => {:rook, :black}},
      7 => %{:a => {:pawn, :black}, :b => {:pawn, :black}, :c => {:pawn, :black}, :d => {:pawn, :black}, :e => {:pawn, :black}, :f => {:pawn, :black}, :g => {:pawn, :black}, :h => {:pawn, :black}},
      6 => %{:a => {:empty, :empty}, :b => {:empty, :empty}, :c => {:empty, :empty}, :d => {:empty, :empty}, :e => {:empty, :empty}, :f => {:empty, :empty}, :g => {:empty, :empty}, :h => {:empty, :empty}},
      5 => %{:a => {:empty, :empty}, :b => {:empty, :empty}, :c => {:empty, :empty}, :d => {:empty, :empty}, :e => {:empty, :empty}, :f => {:empty, :empty}, :g => {:empty, :empty}, :h => {:empty, :empty}},
      4 => %{:a => {:empty, :empty}, :b => {:empty, :empty}, :c => {:empty, :empty}, :d => {:empty, :empty}, :e => {:empty, :empty}, :f => {:empty, :empty}, :g => {:empty, :empty}, :h => {:empty, :empty}},
      3 => %{:a => {:empty, :empty}, :b => {:empty, :empty}, :c => {:empty, :empty}, :d => {:empty, :empty}, :e => {:empty, :empty}, :f => {:empty, :empty}, :g => {:empty, :empty}, :h => {:empty, :empty}},
      2 => %{:a => {:pawn, :white}, :b => {:pawn, :white}, :c => {:pawn, :white}, :d => {:pawn, :white}, :e => {:pawn, :white}, :f => {:pawn, :white}, :g => {:pawn, :white}, :h => {:pawn, :white}},
      1 => %{:a => {:rook, :white}, :b => {:knight, :white}, :c => {:bishop, :white}, :d => {:queen, :white}, :e => {:king, :white}, :f => {:bishop, :white}, :g => {:knight, :white}, :h => {:rook, :white}},
    }
  end

  def list_moves(chessboard, {file, rank}) do
    list_moves(chessboard, {file, rank}, chessboard[rank][file])
  end

  def list_moves(chessboard, {file, rank}, {:pawn, color}) do

  end

  def get_square(chessboard, {file, rank}) do
    chessboard[rank][file]
  end

end
