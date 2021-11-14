defmodule Namedays.Creator do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_stack) do
    get_init_content()
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
    date = Date.utc_today()

    Map.get(state, "#{date.month}-#{date.day}")
    |> IO.inspect()

    {:noreply, state}
  end

  defp get_nameday_date(state, name) do
    state
    |> Enum.find({"-"}, fn {_key, val} -> Enum.member?(val, name) end)
    |> elem(0)
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
end
