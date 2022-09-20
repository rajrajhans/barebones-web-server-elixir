defmodule Main do
  def hello(name) do
    "Howdy, #{name}!"
  end
  def hello() do
    "yo wazzzupp"
  end
end

IO.puts Main.hello("Elixirr")