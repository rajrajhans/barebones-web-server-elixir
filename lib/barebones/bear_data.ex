defmodule Barebones.BearData do
  @moduledoc "module for handling the data for Bears"

  alias Barebones.Bear
  alias Barebones.Fetcher

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
  def get_single_bear_coordinates() do
    :timer.sleep(1000)
    System.unique_integer([:positive])
  end

  # function that waits 500 milliseconds and replies
  def get_bear_snapshot() do
    :timer.sleep(500)
    "bear-snapshot.jpg"
  end

  def get_bear_coordinates() do
    #    this will take one second to finish
    caller_pid = self()

#    spawn(fn -> send(caller_pid, {:result, get_single_bear_coordinates()}) end)
#    spawn(fn -> send(caller_pid, {:result, get_single_bear_coordinates()}) end)
#    spawn(fn -> send(caller_pid, {:result, get_single_bear_coordinates()}) end)
#
#    coord1 = receive do {:result, coord} -> coord end
#    coord2 = receive do {:result, coord} -> coord end
#    coord3 = receive do {:result, coord} -> coord end

    pid1 = Fetcher.async(fn -> get_single_bear_coordinates() end)
    pid2 = Fetcher.async(fn -> get_single_bear_coordinates() end)
    pid3 = Fetcher.async(fn -> get_single_bear_coordinates() end)
    pid4 = Fetcher.async(fn -> get_bear_snapshot() end)

    coord1 = Fetcher.get_result(pid1)
    coord2 = Fetcher.get_result(pid2)
    coord3 = Fetcher.get_result(pid3)
    snapshot = Fetcher.get_result(pid4)

    inspect [coord1, coord2, coord3, {"snapshot -> ", snapshot}]
  end

  def get_bear_coordinates_serially() do
    #    this will take three seconds to finish
    coord1 = get_single_bear_coordinates()
    coord2 = get_single_bear_coordinates()
    coord3 = get_single_bear_coordinates()

    inspect [coord1, coord2, coord3]
  end
  
end
