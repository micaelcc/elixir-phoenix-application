defmodule ElixirPhoenixAppWeb.PostLive.PostComponent do
  use ElixirPhoenixAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"post-#{@post.id}"} class="post-container bg-white shadow-md rounded-lg p-4 mb-4 border border-gray-200">
      <div class="flex items-start space-x-4">
        <div class="w-12 h-12 bg-gray-300 rounded-full"></div>

        <div class="flex-1">
          <div class="font-bold text-gray-800">@{@post.nickname}</div>
          <p class="text-gray-600 mt-1">{@post.content}</p>

          <div class="flex justify-between items-center mt-3 text-gray-500">
            <div class="flex space-x-4">
              <div class="flex items-center space-x-1">
                <a href="#" phx-click="like" phx-target={@myself} class={if @post.likes >= 1, do: "cursor-not-allowed opacity-50", else: ""}>
                  <i class={if @post.likes >= 1, do: "fas fa-heart text-red-500", else: "far fa-heart"}></i>
                  <span>{@post.likes}</span>
                </a>
              </div>
              <div class="flex items-center space-x-1">
                <a href="#" phx-click="repost" phx-target={@myself}>
                  <i class="fas fa-retweet"></i> <span>{@post.reposts}</span>
                </a>
              </div>
            </div>
            <%= if assigns.userId && @post.nickname == assigns.userId do %>
            <div class="flex space-x-3">
              <.link patch={~p"/posts/#{@post.id}/edit"} class="text-blue-500 hover:text-blue-700">
                <i class="far fa-edit"></i>
              </.link>
              <.link
                phx-click="delete"
                phx-value-id={@post.id}
                data-confirm="Are you sure?"
                href="#"
                class="text-red-500 hover:text-red-700"
              >
                <i class="far fa-trash-alt"></i>
              </.link>
            </div>
            <% end %> <!-- Fim do if -->
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    if socket.assigns.post.likes < 1 do
      ElixirPhoenixApp.Timeline.inc_likes(socket.assigns.post)
    end
    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    ElixirPhoenixApp.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end