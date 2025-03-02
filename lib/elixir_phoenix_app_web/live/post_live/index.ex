defmodule ElixirPhoenixAppWeb.PostLive.Index do
  use ElixirPhoenixAppWeb, :live_view

  alias ElixirPhoenixApp.Timeline
  alias ElixirPhoenixApp.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    if !_session["user_token"] do
      {:ok, redirect(socket, to: "/users/log_in")}
    else
      user = ElixirPhoenixApp.Accounts.get_user_by_session_token(_session["user_token"])

      if user do
        if connected?(socket), do: Timeline.subscribe()
        socket =
            socket
            |> assign(:posts, ElixirPhoenixApp.Timeline.list_posts())
            |> assign(:user, user)
            |> assign(:userIdNickname, user.nickname)
        {:ok, socket}
      else
        {:error, redirect(socket, to: "/users/log_in")}
      end
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, assign(socket, :posts, ElixirPhoenixApp.Timeline.list_posts())}
  end


  @impl true
  def handle_info({ElixirPhoenixAppWeb.PostLive.FormComponent, {:updated, post}}, socket) do
      posts = ElixirPhoenixApp.Timeline.list_posts()
      {:noreply, assign(socket, :posts, posts)}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
      user = socket.assigns.user
      attrs = %{nickname: user.nickname, content: post.content}

      case ElixirPhoenixApp.Timeline.update_post(post, attrs) do
        {:ok, updated_post} ->
          {:noreply, update(socket, :posts, fn posts -> [updated_post | posts] end)}
      end

  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
      {:noreply, update(socket, :posts, fn posts -> Timeline.list_posts() end)}
  end
end
