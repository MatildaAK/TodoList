defmodule QlWeb.ListLive.FormComponent do
  use QlWeb, :live_component

  alias Ql.Todos

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Namn" />
        <.input field={@form[:description]} type="text" label="Beskrivning" />
        <:actions>
          <.button phx-disable-with="Saving...">Spara</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{list: list} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Todos.change_list(list))
     end)}
  end

  @impl true
  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset = Todos.change_list(socket.assigns.list, list_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  defp save_list(socket, :edit, list_params) do
    case Todos.update_list(socket.assigns.list, list_params) do
      {:ok, list} ->
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "List updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_list(socket, :new, list_params) do
    user_id = socket.assigns.current_user.id
    list_params = Map.put(list_params, "user_id", user_id)

    case Todos.create_list(list_params) do
      {:ok, list} ->
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
