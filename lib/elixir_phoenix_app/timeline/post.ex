defmodule ElixirPhoenixApp.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :nickname, :string
    field :likes, :integer, default: 0
    field :reposts, :integer, default: 0
    field :deleted, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :likes, :reposts, :deleted, :nickname])
    |> validate_required([:content])
    |> validate_length(:content, min: 2, max: 200)
  end
end
