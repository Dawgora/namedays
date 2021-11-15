defmodule NamedayProviderTest do
  use ExUnit.Case

  describe "nameday provider happy path tests" do
    test "get_date_nameday works with seperate month and day" do
      assert GenServer.call(Namedays.NamedayProvider, {:get_date_nameday, %{month: 1, day: 22}}) == ["Austris"]
    end

    test "get_date_nameday works with a string" do
      assert GenServer.call(Namedays.NamedayProvider, {:get_date_nameday, "10-11"}) == ["Something else", "more"]
    end

    test "get_date_nameday with no data also works" do
      assert GenServer.call(Namedays.NamedayProvider, {:get_date_nameday, "10-12"}) == nil
    end

    test "get_nameday_date returns date by given name" do
      assert GenServer.call(Namedays.NamedayProvider, {:get_nameday_date, "Austris"}) == %{day: "22", month: "01"}
    end

    test "get_nameday_date returns nothing if wrong name is given" do
      assert GenServer.call(Namedays.NamedayProvider, {:get_nameday_date, "yeet"}) == nil
    end

    test "get_todays_namedays returns todays nameday" do
      assert GenServer.call(Namedays.NamedayProvider, :get_todays_namedays) == ["Austris"]
    end
  end
end
