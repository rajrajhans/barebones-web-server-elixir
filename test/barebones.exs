defmodule BarebonesTest do
  use ExUnit.Case
  doctest Barebones

  test "greets the world" do
    assert Barebones.hello() == :world
  end
end
