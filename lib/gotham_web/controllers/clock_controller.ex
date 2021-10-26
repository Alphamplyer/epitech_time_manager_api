defmodule GothamWeb.ClockController do
  use GothamWeb, :controller

  alias Gotham.ClockController
  alias Gotham.ClockController.Clock
  alias Gotham.WorkingTimeController

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    clocks = ClockController.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def toogle_clock(conn, %{"userID" => userId} = _params) do
    try do
      clock = ClockController.get_clock_by_userId(userId)
      is_active = clock.status

      IO.puts("Clock: clock exists")

      clock_params =  %{
          time: (if is_active, do: clock.time, else: DateTime.utc_now()),
          status: !is_active,
          user_id: userId
      }

      if is_active do
        workingtime_params = %{
          start: clock.time,
          end: DateTime.utc_now(),
          user_id: userId
        }

        WorkingTimeController.create_working_time(workingtime_params)
      end

      with {:ok, %Clock{} = clock} <- ClockController.update_clock(clock, clock_params) do
        render(conn, "show.json", clock: clock)
      end
    rescue
      _e ->
        clock_params = %{
          time: DateTime.utc_now(),
          status: true  ,
          user_id: userId
      }

        IO.puts("Clock: clock do not exists");

        with {:ok, %Clock{} = clock} <- ClockController.create_clock(clock_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
          |> render("show.json", clock: clock)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    clock = ClockController.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  # def update(conn, %{"id" => id, "clock" => clock_params}) do
  #   clock = ClockController.get_clock!(id)

  #   with {:ok, %Clock{} = clock} <- ClockController.update_clock(clock, clock_params) do
  #     render(conn, "show.json", clock: clock)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   clock = ClockController.get_clock!(id)

  #   with {:ok, %Clock{}} <- ClockController.delete_clock(clock) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
