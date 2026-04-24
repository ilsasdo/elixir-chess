defmodule Chess.Repo.Migrations.RenameStatusToFen do
  use Ecto.Migration

  def change do
    rename table(:games), :status, to: :fen
  end
end
