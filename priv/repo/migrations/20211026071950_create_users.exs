defmodule Gotham.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, unique: true, null: false
      add :email, :string, unique: true, null: false

      timestamps()
    end

    create unique_index(:users, [:username], name: :users_username_unique_index)
    create unique_index(:users, [:email], name: :users_email_unique_index)
  end
end
