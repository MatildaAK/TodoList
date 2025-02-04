defmodule QlWeb.UserLoginLive do
  use QlWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Logga in på konto
        <:subtitle>
          Har du inget konto?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            registrera dig
          </.link>
          för ett konto nu.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Lösenord" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Håll mig inloggad" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Glömt lösenord?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Logga in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
