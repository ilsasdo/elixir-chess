defmodule Chess.Infrastructure.Schema.Game do
  use Ecto.Schema

  schema "games" do
    field :fen, :string

    timestamps()
  end
end
