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
  def get_moves(squares, position) do
    sq = get_square(squares, position)
    case sq do
      :empty -> []
      {shape, color} -> get_moves(squares, position, shape, color)
    end
  end

  @spec get_moves(squares(), position()) :: [position()]
  def get_moves(squares, position, :pawn, color) do
    pos_n = pos(position, :n)
    pos_nn = pos(pos_n, :n)
    pos_ne = pos(pos_n, :e)
    pos_nw = pos(pos_n, :w)

    [ {pos_n, &is_empty/1},
      {pos_nn, &(is_empty(&1) && is_pawn_starting_position(position, color))},
      {pos_ne, &(is_opponent(&1, color))},
      {pos_nw, &(is_opponent(&1, color))}]
      |> Enum.filter(fn {p, f} -> f.(Board.get_square(squares, p)) end)
      |> Enum.map(fn {p, f} -> p end)
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

end
