defmodule Gotham.ClockControllerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.ClockController` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2021-10-25 07:21:00]
      })
      |> Gotham.ClockController.create_clock()

    clock
  end
end
