defmodule Gotham.UserController.User do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoCommons.EmailValidator

  schema "users" do
    field :username, :string
    field :email, :string
    has_one :clock, Gotham.ClockController.Clock
    has_many :working_times, Gotham.WorkingTimeController.WorkingTime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_email(:email)
    |> validate_required([:username, :email])
    |> unique_constraint(:username, name: :users_username_unique_index)
    |> unique_constraint(:email, name: :users_email_unique_index)
  end
end
