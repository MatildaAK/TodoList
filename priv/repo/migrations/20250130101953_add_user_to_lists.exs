defmodule Ql.Repo.Migrations.AddUserToLists do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
