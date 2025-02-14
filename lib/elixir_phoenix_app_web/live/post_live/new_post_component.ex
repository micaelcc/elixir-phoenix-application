defmodule ElixirPhoenixAppWeb.PostLive.NewPostComponent do
  use ElixirPhoenixAppWeb, :live_component

  alias ElixirPhoenixApp.Timeline

  @impl true
  def render(assigns) do
    input_value = assigns[:input_value] || ""

    ~H"""
    <div class="post-container bg-white shadow-md rounded-lg p-4 mb-4 border border-gray-200">
      <div class="flex items-start space-x-4">
        <!-- Avatar -->
        <div class="w-12 h-12 bg-gray-300 rounded-full"></div>

        <!-- Input e botão -->
        <div class="flex-1">
          <form phx-submit="save" phx-target={@myself}>
            <input
              type="text"
              name="post[content]"
              placeholder="Whats happening ?"
              value={input_value}
              class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <div class="flex justify-end mt-2">
              <.button type="submit">New Post</.button>
            </div>
          </form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("save", %{"post" => %{"content" => content}}, socket) do
    IO.inspect(socket)
    case Timeline.create_post(%{content: content}) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> assign(:input_value, "")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
