defmodule ElixirPhoenixApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :nickname, :string
      add :content, :string
      add :likes, :integer
      add :reposts, :integer
      add :deleted, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
