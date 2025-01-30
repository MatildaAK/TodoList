defmodule Ql.Todos.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ql.Accounts.User

  schema "lists" do
    field :name, :string
    field :description, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs \\ %{}) do
    list
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :user_id])
  end
end
