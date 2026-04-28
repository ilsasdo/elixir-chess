defmodule ChessWeb.GameController do
  use Phoenix.Controller, formats: [:json]

  def index(conn, _params) do
    games = Chess.Infrastructure.Games.list_games()
    json(conn, games |> Enum.map(&to_json(&1)))
  end

  def create(conn, _params) do
    cmd = %Chess.Domain.Commands.CreateGame{id: UUID.uuid4()}

    res = Chess.CommandedApplication.dispatch(cmd)
    #    json(conn, res)
    IO.inspect(res, label: "DEBUG" )
    case res do
      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: "error"})

      _ ->
        conn |> json(%{status: "ok"})
    end

    # json(conn, %{status: "ok"})
  end

  def show(conn, %{"id" => id}) do
    board = Chess.Infrastructure.Games.get_game!(id)
    json(conn, to_json(id, board))
  end

  def move(conn, %{"id" => id, "from" => from, "to" => to}) do
    cmd = %Chess.Domain.Commands.MakeMove{id: id, from: from, to: to}

    case Chess.CommandedApplication.dispatch(cmd) do
      :ok ->
        json(conn, %{status: "ok"})

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end

  defp to_json(board) do
    %{
      id: board.id,
      board: squares_to_json(board.squares)
    }
  end

  defp to_json(id, board) do
    %{
      id: id,
      board: squares_to_json(board.squares)
    }
  end

  defp squares_to_json(squares) do
    0..7
    |> Enum.map(fn y ->
      0..7
      |> Enum.map(fn x ->
        piece_to_json(squares[{x, y}])
      end)
    end)
  end

  defp piece_to_json(piece) do
    piece_string =
      case piece do
        {:pawn, _} -> "p"
        {:rook, _} -> "r"
        {:queen, _} -> "q"
        {:knight, _} -> "n"
        {:king, _} -> "k"
        {:bishop, _} -> "b"
        _ -> ""
      end

    case piece do
      {_, :white} -> piece_string |> String.upcase()
      {_, :black} -> piece_string
      _ -> piece_string
    end
  end
end
