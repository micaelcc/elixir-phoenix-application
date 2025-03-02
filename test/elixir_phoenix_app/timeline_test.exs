defmodule ElixirPhoenixApp.TimelineTest do
  use ElixirPhoenixApp.DataCase

  alias ElixirPhoenixApp.Timeline

  describe "posts" do
    alias ElixirPhoenixApp.Timeline.Post

    import ElixirPhoenixApp.TimelineFixtures

    @invalid_attrs %{nickname: nil, content: nil, likes: nil, reposts: nil, deleted: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Timeline.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Timeline.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{nickname: "some nickname", content: "some content", likes: 42, reposts: 42, deleted: true}

      assert {:ok, %Post{} = post} = Timeline.create_post(valid_attrs)
      assert post.nickname == "some nickname"
      assert post.content == "some content"
      assert post.likes == 42
      assert post.reposts == 42
      assert post.deleted == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{nickname: "some updated nickname", content: "some updated content", likes: 43, reposts: 43, deleted: false}

      assert {:ok, %Post{} = post} = Timeline.update_post(post, update_attrs)
      assert post.nickname == "some updated nickname"
      assert post.content == "some updated content"
      assert post.likes == 43
      assert post.reposts == 43
      assert post.deleted == false
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_post(post, @invalid_attrs)
      assert post == Timeline.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Timeline.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Timeline.change_post(post)
    end
  end
end
