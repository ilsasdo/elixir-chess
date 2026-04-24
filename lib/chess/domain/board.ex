defmodule Chess.Domain.Board do
  defstruct id: 0, squares: %{}

  @type position :: {0..7, 0..7}
  @type color :: :white | :black
  @type shape :: :pawn | :rook | :knight | :bishop | :queen | :king
  @type piece :: {shape(), color()}
  @type square :: :empty | piece()
  @type squares :: %{position() => square()}

  @type t :: %__MODULE__{
          id: integer(),
          squares: squares()
        }

  @spec new :: t()
  def new do
    %__MODULE__{
      id: 0,
      squares: init()
    }
  end

  @spec to_fen(t()) :: string()
  def to_fen(board) do
    board_fen =
      7..0
      |> Enum.map(fn y ->
        0..7
        |> Enum.map(fn x -> piece_to_fen(get_square(board, {x, y})) end)
        |> Enum.join()
        |> String.replace("11111111", "8")
        |> String.replace("1111111", "7")
        |> String.replace("111111", "6")
        |> String.replace("11111", "5")
        |> String.replace("1111", "4")
        |> String.replace("111", "3")
        |> String.replace("11", "2")
      end)
      |> Enum.join("/")

    board_fen <> " w KQkq - 0 1"
  end

  @spec from_fen(string()) :: t()
  def from_fen(fen) do
    [board_fen, _turn, _castle, _en_passant, _halfmove_clock, _fullmove_clock] =
      String.split(fen, " ")

    rows =
      board_fen
      |> String.replace("8", "11111111")
      |> String.replace("7", "1111111")
      |> String.replace("6", "111111")
      |> String.replace("5", "11111")
      |> String.replace("4", "1111")
      |> String.replace("3", "111")
      |> String.replace("2", "11")
      |> String.split("/")
      |> Enum.reverse()

    # for each row, produce
    squares = rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {col, x} ->
        {x, y, fen_to_piece(col)}
      end)
    end)
    |> Enum.reduce(%{}, fn {x, y, piece}, acc -> Map.put(acc, {x, y}, piece) end)
    require IEx; IEx.pry()
    %__MODULE__{
      squares: squares
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

  @spec get_square(t(), string()) :: square()
  def get_square(board, string_position) when is_binary(string_position) do
    get_square(board, string_to_position(string_position))
  end

  @spec get_square(t(), position()) :: square()
  def get_square(board, {x, y}) do
    get_square(board, x, y)
  end

  @spec get_square(t(), integer(), integer()) :: square()
  def get_square(board, x, y) do
    square = board.squares[{x, y}]

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
      :ne -> {x, y} |> pos(:n) |> pos(:e)
      :nw -> {x, y} |> pos(:n) |> pos(:w)
      :se -> {x, y} |> pos(:s) |> pos(:e)
      :sw -> {x, y} |> pos(:s) |> pos(:w)
    end
  end

  def pos_range(p, direction) do
    Stream.unfold(pos(p, direction), fn p2 -> {p2, pos(p2, direction)} end)
    |> Enum.take_while(&is_valid_position/1)
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, {x, y}) do
    sq = get_square(board, {x, y})

    case sq do
      :empty -> []
      {shape, color} -> get_moves(board, {x, y}, shape, color)
    end
  end

  @spec get_moves(t(), String.t()) :: [String.t()]
  def get_moves(board, string_position) when is_binary(string_position) do
    pos = string_position |> string_to_position
    get_moves(board, pos) |> Enum.map(&position_to_string/1)
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, position, :pawn, :white) do
    pos_n = pos(position, :n)
    pos_nn = pos(pos_n, :n)
    pos_ne = pos(pos_n, :e)
    pos_nw = pos(pos_n, :w)

    [
      {pos_n, &is_empty/1},
      {pos_nn, &(is_empty(&1) && is_pawn_starting_position(position, :white))},
      {pos_ne, &is_opponent(&1, :white)},
      {pos_nw, &is_opponent(&1, :white)}
    ]
    |> Enum.filter(fn {p, f} -> f.(get_square(board, p)) end)
    |> Enum.map(fn {p, _f} -> p end)
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, position, :pawn, :black) do
    pos_s = pos(position, :s)
    pos_ss = pos(pos_s, :s)
    pos_se = pos(pos_s, :e)
    pos_sw = pos(pos_s, :w)

    [
      {pos_s, &is_empty/1},
      {pos_ss, &(is_empty(&1) && is_pawn_starting_position(position, :black))},
      {pos_se, &is_opponent(&1, :black)},
      {pos_sw, &is_opponent(&1, :black)}
    ]
    |> Enum.filter(fn {p, f} -> f.(get_square(board, p)) end)
    |> Enum.map(fn {p, _f} -> p end)
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, position, :knight, color) do
    pos_nne = position |> pos(:n) |> pos(:n) |> pos(:e)
    pos_nnw = position |> pos(:n) |> pos(:n) |> pos(:w)
    pos_sse = position |> pos(:s) |> pos(:s) |> pos(:e)
    pos_ssw = position |> pos(:s) |> pos(:s) |> pos(:w)
    pos_een = position |> pos(:e) |> pos(:e) |> pos(:n)
    pos_ees = position |> pos(:e) |> pos(:e) |> pos(:s)
    pos_wwn = position |> pos(:w) |> pos(:w) |> pos(:n)
    pos_wws = position |> pos(:w) |> pos(:w) |> pos(:s)

    [
      pos_nne,
      pos_nnw,
      pos_sse,
      pos_ssw,
      pos_een,
      pos_ees,
      pos_wwn,
      pos_wws
    ]
    |> Enum.filter(fn p -> is_valid_position(p) end)
    |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, {x, y}, :rook, color) do
    range_n =
      pos_range({x, y}, :n)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_s =
      pos_range({x, y}, :s)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_w =
      pos_range({x, y}, :w)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_e =
      pos_range({x, y}, :e)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_n ++ range_e ++ range_s ++ range_w
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, {x, y}, :bishop, color) do
    range_ne =
      pos_range({x, y}, :ne)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_nw =
      pos_range({x, y}, :nw)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_se =
      pos_range({x, y}, :se)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_sw =
      pos_range({x, y}, :sw)
      |> take_until_inclusive(fn p -> !is_empty(get_square(board, p)) end)
      |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)

    range_ne ++ range_nw ++ range_se ++ range_sw
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, {x, y}, :queen, color) do
    Enum.concat(get_moves(board, {x, y}, :bishop, color), get_moves(board, {x, y}, :rook, color))
  end

  @spec get_moves(t(), position()) :: [position()]
  def get_moves(board, position, :king, color) do
    pos_n = position |> pos(:n)
    pos_s = position |> pos(:s)
    pos_e = position |> pos(:e)
    pos_w = position |> pos(:w)
    pos_ne = position |> pos(:ne)
    pos_nw = position |> pos(:nw)
    pos_se = position |> pos(:se)
    pos_sw = position |> pos(:sw)

    [
      pos_n,
      pos_s,
      pos_e,
      pos_w,
      pos_ne,
      pos_nw,
      pos_se,
      pos_sw
    ]
    |> Enum.filter(fn p -> is_valid_position(p) end)
    |> Enum.filter(fn p -> is_empty_or_opponent(get_square(board, p), color) end)
  end

  defp take_until_inclusive([], _predicate) do
    []
  end

  defp take_until_inclusive([head | tail], predicate) do
    if predicate.(head) do
      [head]
    else
      [head | take_until_inclusive(tail, predicate)]
    end
  end

  @spec move(t(), position(), position()) :: squares()
  def move(board, position_from, position_to)
      when is_binary(position_from) and is_binary(position_to) do
    pos_from = string_to_position(position_from)
    pos_to = string_to_position(position_to)
    move(board, pos_from, pos_to)
  end

  @spec move(t(), position(), position()) :: squares()
  def move(board, position_from, position_to) do
    piece_from = board.squares[position_from]

    %{
      board
      | squares:
          board.squares
          |> Map.put(position_from, :empty)
          |> Map.put(position_to, piece_from)
    }
  end

  defp is_pawn_starting_position({_x, y}, color) do
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

  defp is_opponent({_shape, color}, my_color) do
    if color == my_color do
      false
    else
      true
    end
  end

  defp is_opponent(:empty, _my_color) do
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

    x =
      case Enum.at(gp, 0) do
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

    y =
      case Enum.at(gp, 1) do
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
    f =
      case x do
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

    r =
      case y do
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

    f <> r
  end

  defp fen_to_piece(fen) do
    case fen do
      "P" -> {:pawn, :white}
      "p" -> {:pawn, :black}
      "R" -> {:rook, :white}
      "r" -> {:rook, :black}
      "B" -> {:bishop, :white}
      "b" -> {:bishop, :black}
      "N" -> {:knight, :white}
      "n" -> {:knight, :black}
      "K" -> {:king, :white}
      "k" -> {:king, :black}
      "Q" -> {:queen, :white}
      "q" -> {:queen, :black}
      _ -> :empty
    end
  end

  defp piece_to_fen(piece) do
    piece_string =
      case piece do
        {:pawn, _} -> "p"
        {:rook, _} -> "r"
        {:queen, _} -> "q"
        {:knight, _} -> "n"
        {:king, _} -> "k"
        {:bishop, _} -> "b"
        _ -> "1"
      end

    case piece do
      {_, :white} -> piece_string |> String.upcase()
      {_, :black} -> piece_string
      _ -> piece_string
    end
  end
end
