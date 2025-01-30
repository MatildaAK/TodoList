defmodule Ql.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ql.Todos` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Ql.Todos.create_list()

    list
  end
end
