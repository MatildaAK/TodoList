defmodule QlWeb.ListLive.Index do
  use QlWeb, :live_view

  alias Ql.Todos
  alias Ql.Todos.List

  @impl true
  def mount(_params, _session, socket) do
    if socket.assigns[:current_user] do
      user_id = socket.assigns.current_user.id

      socket =
        socket
        |> stream(:lists, Todos.list_lists(user_id))

      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply,
     socket
     |> assign(:current_user, socket.assigns.current_user)
     |> apply_action(socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Uppdatera lista")
    |> assign(:list, Todos.get_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Ny lista")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Min lista")
    |> assign(:list, nil)
  end

  @impl true
  def handle_info({QlWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply, stream_insert(socket, :lists, list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Todos.get_list!(id)
    {:ok, _} = Todos.delete_list(list)

    {:noreply, stream_delete(socket, :lists, list)}
  end
end
