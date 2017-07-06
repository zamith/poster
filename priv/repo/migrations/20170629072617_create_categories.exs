defmodule Poster.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :description, :text, null: false
      add :parent_id, references(:categories)

      timestamps()
    end
  end
end
