defmodule ElixirPhoenixApp.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirPhoenixApp.Timeline` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        deleted: true,
        likes: 42,
        nickname: "some nickname",
        reposts: 42
      })
      |> ElixirPhoenixApp.Timeline.create_post()

    post
  end
end
