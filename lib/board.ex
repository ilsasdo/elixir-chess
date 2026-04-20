defmodule Board do
  defstruct squares: %{}

  @type position :: {0..7, 0..7}
  @type color :: :white | :black
  @type shape :: :pawn | :rook | :knight | :bishop | :queen | :king
  @type piece :: {shape(), color()}
  @type square :: :empty | piece()
  @type squares :: %{position() => square()}

  @type t :: %__MODULE__{
          squares: squares()
        }

  @spec new :: t()
  def new do
    %__MODULE__{
      squares: init()
    }
  end

  @spec init :: squares()
  defp init do
    %{
      {0, 0} => {:rook, :white},
      {1, 0} => {:knight, :white},
      {2, 0} => {:bishop, :white},
      {3, 0} => {:queen, :white},
      {4, 0} => {:king, :white},
      {5, 0} => {:bishop, :white},
      {6, 0} => {:knight, :white},
      {7, 0} => {:rook, :white},
      {0, 1} => {:pawn, :white},
      {1, 1} => {:pawn, :white},
      {2, 1} => {:pawn, :white},
      {3, 1} => {:pawn, :white},
      {4, 1} => {:pawn, :white},
      {5, 1} => {:pawn, :white},
      {6, 1} => {:pawn, :white},
      {7, 1} => {:pawn, :white},
      {0, 2} => :empty,
      {1, 2} => :empty,
      {2, 2} => :empty,
      {3, 2} => :empty,
      {4, 2} => :empty,
      {5, 2} => :empty,
      {6, 2} => :empty,
      {7, 2} => :empty,
      {0, 3} => :empty,
      {1, 3} => :empty,
      {2, 3} => :empty,
      {3, 3} => :empty,
      {4, 3} => :empty,
      {5, 3} => :empty,
      {6, 3} => :empty,
      {7, 3} => :empty,
      {0, 4} => :empty,
      {1, 4} => :empty,
      {2, 4} => :empty,
      {3, 4} => :empty,
      {4, 4} => :empty,
      {5, 4} => :empty,
      {6, 4} => :empty,
      {7, 4} => :empty,
      {0, 5} => :empty,
      {1, 5} => :empty,
      {2, 5} => :empty,
      {3, 5} => :empty,
      {4, 5} => :empty,
      {5, 5} => :empty,
      {6, 5} => :empty,
      {7, 5} => :empty,
      {0, 6} => {:pawn, :black},
      {1, 6} => {:pawn, :black},
      {2, 6} => {:pawn, :black},
      {3, 6} => {:pawn, :black},
      {4, 6} => {:pawn, :black},
      {5, 6} => {:pawn, :black},
      {6, 6} => {:pawn, :black},
      {7, 6} => {:pawn, :black},
      {0, 7} => {:rook, :black},
      {1, 7} => {:knight, :black},
      {2, 7} => {:bishop, :black},
      {3, 7} => {:queen, :black},
      {4, 7} => {:king, :black},
      {5, 7} => {:bishop, :black},
      {6, 7} => {:knight, :black},
      {7, 7} => {:rook, :black}
    }
  end

  @spec get_square(squares(), position()) :: square()
  def get_square(squares, {x, y}) do
    get_square(squares, x, y)
  end

  @spec get_square(squares(), integer(), integer()) :: square()
  def get_square(squares, x, y) do
    square = squares[{x, y}]
    if is_nil(square) do
      :empty
    else
      square
    end
  end

  @spec pos(position(), atom()) :: position()
  def pos({x, y}, direction) do
    case direction do
      :n -> {x, y + 1}
      :s -> {x, y - 1}
      :e -> {x + 1, y}
      :w -> {x - 1, y}
    end
  end

  @spec get_moves(squares(), position()) :: [position()]
  def get_moves(squares, {x, y}) do
    sq = get_square(squares, {x, y})
    case sq do
      :empty -> []
      {shape, color} -> get_moves(squares, {x, y}, shape, color)
    end
  end

  @spec get_moves(squares(), String.t()) :: [String.t()]
  def get_moves(squares, string_position) when is_binary(string_position) do
    pos = string_position |> string_to_position
    get_moves(squares, pos) |> Enum.map(&position_to_string/1)
  end

  @spec get_moves(squares(), position()) :: [position()]
  def get_moves(squares, position, :pawn, :white) do
    pos_n = pos(position, :n)
    pos_nn = pos(pos_n, :n)
    pos_ne = pos(pos_n, :e)
    pos_nw = pos(pos_n, :w)

    [ {pos_n, &is_empty/1},
      {pos_nn, &(is_empty(&1) && is_pawn_starting_position(position, :white))},
      {pos_ne, &(is_opponent(&1, :white))},
      {pos_nw, &(is_opponent(&1, :white))}]
      |> Enum.filter(fn {p, f} -> f.(Board.get_square(squares, p)) end)
      |> Enum.map(fn {p, f} -> p end)
  end

  @spec get_moves(squares(), position()) :: [position()]
  def get_moves(squares, position, :pawn, :black) do
    pos_s = pos(position, :s)
    pos_ss = pos(pos_s, :s)
    pos_se = pos(pos_s, :e)
    pos_sw = pos(pos_s, :w)

    [ {pos_s, &is_empty/1},
      {pos_ss, &(is_empty(&1) && is_pawn_starting_position(position, :black))},
      {pos_se, &(is_opponent(&1, :black))},
      {pos_sw, &(is_opponent(&1, :black))}]
      |> Enum.filter(fn {p, f} -> f.(Board.get_square(squares, p)) end)
      |> Enum.map(fn {p, f} -> p end)
  end

  @spec get_moves(squares(), position()) :: [position()]
  def get_moves(squares, position, :knight, color) do
    pos_nne = position |> pos(:n) |> pos(:n) |> pos(:e)
    pos_nnw = position |> pos(:n) |> pos(:n) |> pos(:w)
    pos_sse = position |> pos(:s) |> pos(:s) |> pos(:e)
    pos_ssw = position |> pos(:s) |> pos(:s) |> pos(:w)
    pos_een = position |> pos(:e) |> pos(:e) |> pos(:n)
    pos_ees = position |> pos(:e) |> pos(:e) |> pos(:s)
    pos_wwn = position |> pos(:w) |> pos(:w) |> pos(:n)
    pos_wws = position |> pos(:w) |> pos(:w) |> pos(:s)

    [ {pos_nne, &(is_empty_or_opponent(&1, color))},
      {pos_nnw, &(is_empty_or_opponent(&1, color))},
      {pos_sse, &(is_empty_or_opponent(&1, color))},
      {pos_ssw, &(is_empty_or_opponent(&1, color))},
      {pos_een, &(is_empty_or_opponent(&1, color))},
      {pos_ees, &(is_empty_or_opponent(&1, color))},
      {pos_wwn, &(is_empty_or_opponent(&1, color))},
      {pos_wws, &(is_empty_or_opponent(&1, color))},
    ] |> Enum.filter(fn {p, _f} -> is_valid_position(p) end)
      |> Enum.filter(fn {p, f} -> f.(Board.get_square(squares, p)) end)
      |> Enum.map(fn {p, _f} -> p end)
  end

  @spec move(squares(), position(), position()) :: squares()
  def move(squares, position_from, position_to) do
    piece_from = squares[position_from]
    squares
      |> Map.put(position_from, :empty)
      |> Map.put(position_to, piece_from)
  end

  defp is_pawn_starting_position({x, y}, color) do
    case color do
      :white -> y == 1
      :black -> y == 6
    end
  end

  defp is_empty_or_opponent(piece, my_color) do
    is_empty(piece) || is_opponent(piece, my_color)
  end

  defp is_empty(piece) do
    case piece do
      :empty -> true
      _ -> false
    end
  end

  defp is_opponent({shape, color}, my_color) do
    if color == my_color do
      false
    else
      true
    end
  end

  defp is_opponent(:empty, my_color) do
    false
  end

  defp is_valid_position({x, y}) do
    if x in 0..7 && y in 0..7 do
      true
    else
      false
    end
  end

  defp string_to_position(string_position) do
    gp = String.graphemes(string_position)
    x = case Enum.at(gp, 0) do
      "a" -> 0
      "b" -> 1
      "c" -> 2
      "d" -> 3
      "e" -> 4
      "f" -> 5
      "g" -> 6
      "h" -> 7
      _ -> 9
    end
    y = case Enum.at(gp, 1) do
      "1" -> 0
      "2" -> 1
      "3" -> 2
      "4" -> 3
      "5" -> 4
      "6" -> 5
      "7" -> 6
      "8" -> 7
      _ -> 9
    end

    {x, y}
  end

  defp position_to_string({x, y}) do
    f = case x do
      0 -> "a"
      1 -> "b"
      2 -> "c"
      3 -> "d"
      4 -> "e"
      5 -> "f"
      6 -> "g"
      7 -> "h"
      _ -> 9
    end
    r = case y do
      0 -> "1"
      1 -> "2"
      2 -> "3"
      3 -> "4"
      4 -> "5"
      5 -> "6"
      6 -> "7"
      7 -> "8"
      _ -> 9
    end
    f<>r
  end

end
