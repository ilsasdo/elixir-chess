defmodule Chess.Repo.Migrations.GameIdToUuid do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :uuid, :uuid
    end
  end
end
