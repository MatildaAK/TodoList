defmodule Ql.Repo.Migrations.AddDescriptionToLists do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :description, :text
    end
  end
end
