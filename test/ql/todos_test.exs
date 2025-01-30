defmodule Ql.TodosTest do
  use Ql.DataCase

  alias Ql.Todos

  describe "lists" do
    alias Ql.Todos.List

    import Ql.TodosFixtures

    @invalid_attrs %{name: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Todos.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Todos.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %List{} = list} = Todos.create_list(valid_attrs)
      assert list.name == "some name"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %List{} = list} = Todos.update_list(list, update_attrs)
      assert list.name == "some updated name"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_list(list, @invalid_attrs)
      assert list == Todos.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Todos.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Todos.change_list(list)
    end
  end
end
