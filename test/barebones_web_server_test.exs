defmodule BarebonesWebServerTest do
  use ExUnit.Case
  doctest BarebonesWebServer

  test "greets the world" do
    assert BarebonesWebServer.hello() == :world
  end
end
