defmodule Chess.Infrastructure.GameProjection do
  use Commanded.Projections.Ecto,
      application: Chess.CommandedApplication,
      repo: Chess.Repo,
      name: "game_projection"

  alias Chess.Domain.Events.GameCreated
  alias Chess.Domain.Events.MoveMade
  alias Chess.Infrastructure.Schema.Game

  project %GameCreated{id: id, fen: fen} = event, _meta do
    %Chess.Infrastructure.Schema.Game{uuid: id, fen: fen}
    |> Chess.Repo.insert()
  end

  project %MoveMade{id: id, fen: fen} = event, _meta do
    from(g in Game, where: g.uuid == ^id)
    |> Repo.update_all(set: [fen: fen])
  end
end
