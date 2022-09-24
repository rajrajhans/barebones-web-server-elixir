defmodule Barebones.Fetcher do
  def async(fun) do
    parent = self()
    spawn(fn -> send(parent, {:result, fun.()}) end)
  end

  def get_result do
    receive do {:result, val} -> val  end
  end
end