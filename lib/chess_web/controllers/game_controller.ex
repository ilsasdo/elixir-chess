defmodule ChessWeb.GameController do
  use Phoenix.Controller, formats: [:json]

  def index(conn, _params) do
    games = Chess.list_games()
    json(conn, games)
  end

  def show(conn, %{"id" => id}) do
    game = Chess.get_game!(id)
    json(conn, game)
  end

  def move(conn, %{"id" => id, "from" => from, "to" => to}) do
    case Chess.make_move(id, from, to) do
      {:ok, game} ->
        json(conn, game)

      {:error, reason} ->
        conn |> put_status(:bad_request) |> json(%{error: inspect(reason)})
    end
  end
end
