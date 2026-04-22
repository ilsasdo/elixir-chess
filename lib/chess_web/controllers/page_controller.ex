defmodule ChessWeb.PageController do
  use Phoenix.Controller, formats: [:html, :json]

  def index(conn, _params) do
    send_resp(conn, 200, "Hello from Phoenix")
  end
end