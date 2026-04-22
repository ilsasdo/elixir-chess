defmodule ChessWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChessWeb do
    pipe_through :api

    get "/games", GameController, :index
    post "/games", GameController, :create
    get "/games/:id", GameController, :show
    put "/games/:id/move", GameController, :move
  end

  scope "/", ChessWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end