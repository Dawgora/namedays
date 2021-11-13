defmodule NamedaysTest do
  use ExUnit.Case
  doctest Namedays

  test "greets the world" do
    assert Namedays.hello() == :world
  end
end
