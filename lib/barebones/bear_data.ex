defmodule Barebones.BearData do
  @moduledoc "module for handling the data for Bears"

  alias Barebones.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", is_hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black"},
      %Bear{id: 3, name: "Paddington", type: "Brown"},
      %Bear{id: 4, name: "Scarface", type: "Grizzly", is_hibernating: true},
      %Bear{id: 5, name: "Snow", type: "Polar"},
      %Bear{id: 6, name: "Brutus", type: "Grizzly"},
      %Bear{id: 7, name: "Rosie", type: "Black", is_hibernating: true},
      %Bear{id: 8, name: "Roscoe", type: "Panda"},
      %Bear{id: 9, name: "Iceman", type: "Polar", is_hibernating: true},
      %Bear{id: 10, name: "Kenai", type: "Grizzly"}
    ]
  end

  def find_bear(id) when is_integer(id) do
    list_bears() |> Enum.find(fn bear -> bear.id === id end)
  end

  def find_bear(id) when is_binary(id) do
    id |> String.to_integer |> find_bear
  end

  # function that waits 1 second and replies with a random number
  def get_bear_coordinates() do
    :timer.sleep(1000)
    System.unique_integer([:positive]) |> Integer.to_string
  end
  
end
