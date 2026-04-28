defmodule Chess.Infrastructure.Schema.Game do
  use Ecto.Schema

  schema "games" do
    field :fen, :string
    field :uuid, Ecto.UUID, autogenerate: true

    timestamps()
  end

  def changeset(game, attrs) do
    game
    |> Ecto.Changeset.cast(attrs, [:fen])
    |> Ecto.Changeset.validate_required([:fen])
  end
end
