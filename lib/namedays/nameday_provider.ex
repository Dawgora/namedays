defmodule Namedays.NamedayProvider do
  use GenServer

  @handler Application.compile_env(:namedays, :datetime_implementation) || Namedays.DateTimeHelper

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_stack) do
    get_init_content()
  end

  def handle_call({:get_date_nameday, %{month: month, day: day}}, _from, state) do
    get_namedays_by_listed_date([month, day], state)

    {:reply, get_namedays_by_listed_date([month, day], state), state}
  end

  def handle_call({:get_date_nameday, nameday}, _from, state) do
    {:reply, Map.get(state, nameday), state}
  end

  def handle_call({:get_nameday_date, name}, _from, state) do
    {:reply, get_nameday_date(state, name), state}
  end

  def handle_call(:get_todays_namedays, _from, state) do
    data =
      get_todays_listed_month_and_day()
      |> get_namedays_by_listed_date(state)

    {:reply, data, state}
  end

  def get_todays_listed_month_and_day() do
    {:ok, %DateTime{month: month, day: day}} = @handler.now()
    [month, day]
  end

  defp get_nameday_date(state, name) do
    state
    |> Enum.find({"-"}, fn {_key, val} -> Enum.member?(val, name) end)
    |> elem(0)
    |> convert_string_date_to_mapped_date
  end

  defp get_init_content() do
    stack =
      Application.fetch_env!(:namedays, :content_files)
      |> Enum.map(fn file -> read_and_decode_json_file(file) end)
      |> Enum.reduce(fn x, content ->
        Map.merge(x, content, fn _k, v1, v2 ->
          v1 ++ v2
        end)
      end)

    {:ok, stack}
  end

  defp read_and_decode_json_file(file), do: Application.app_dir(:namedays, file) |> File.read! |> Jason.decode!()

  defp convert_string_date_to_mapped_date(string_date) when string_date == "-", do: nil

  defp convert_string_date_to_mapped_date(string_date) when is_bitstring(string_date) do
    [month, day] = String.split(string_date, "-")

    %{month: month, day: day}
  end

  defp get_namedays_by_listed_date([_month, _day] = date, state) do
    date
    |> Enum.map(fn value -> Integer.to_string(value) |> String.pad_leading(2, "0") end)
    |> Enum.reduce(fn elem, carry -> carry <> "-" <> elem end)
    |> (&Map.get(state, &1)).()
  end
end
