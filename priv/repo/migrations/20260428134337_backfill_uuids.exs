defmodule Chess.Repo.Migrations.BackfillUuids do
  use Ecto.Migration

  def change do
    execute("""
    UPDATE games SET uuid = gen_random_uuid()
    """)
  end
end
