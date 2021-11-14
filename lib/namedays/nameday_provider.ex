defmodule Namedays.NamedayProvider do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_stack) do
    get_init_content()
  end

  def handle_cast({:get_date_nameday, %{month: month, day: day}}, state) do
    get_namedays_by_listed_date([month, day], state)

    {:noreply, state}
  end

  def handle_cast({:get_date_nameday, nameday}, state) do
    Map.get(state, nameday)
    |> IO.inspect()

    {:noreply, state}
  end

  def handle_cast({:get_nameday_date, name}, state) do
    get_nameday_date(state, name)
    |> IO.inspect()

    {:noreply, state}
  end

  def handle_cast(:get_todays_namedays, state) do
    {:ok, %DateTime{month: month, day: day}} = Application.fetch_env!(:namedays, :timezone) |> DateTime.now()

    get_namedays_by_listed_date([month, day], state)

    {:noreply, state}
  end

  defp get_nameday_date(state, name) do
    state
    |> Enum.find({"-"}, fn {_key, val} -> Enum.member?(val, name) end)
    |> elem(0)
    |> convert_string_date_to_mapped_date
  end

  defp get_init_content() do
    stack = Application.fetch_env!(:namedays, :content_files)
    |> Enum.map(fn file -> read_and_decode_json_file(file) end)
    |> Enum.reduce(fn x, content ->
        Map.merge(x, content, fn _k, v1, v2 ->
          v1 ++ v2
      end)
    end)

    {:ok, stack}
  end

  defp read_and_decode_json_file(file) do
    {:ok, namedaysContent} = File.read(file)
    Jason.decode!(namedaysContent)
  end

  defp convert_string_date_to_mapped_date(string_date) when is_bitstring(string_date) do
      [month, day] = String.split(string_date, "-")

      %{month: month, day: day}
  end

  defp get_namedays_by_listed_date([_month, _day] = date, state) do
    date
    |> Enum.map(fn value -> Integer.to_string(value) |> String.pad_leading(2, "0") end)
    |> Enum.reduce(fn (elem, carry) -> carry<>"-"<>elem end)
    |> (&Map.get(state, &1)).()
    |> IO.inspect()
  end
end
