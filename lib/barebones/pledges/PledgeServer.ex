defmodule Barebones.Pledges.PledgeServer do
  @doc """
  this module provides functions for creating and getting pledges. The `listen_loop` function will be run in a server process, which will be long lived. It will maintain the actual state. (it is long lived because it recursively calls itself with the updated state, thus "storing" the state) `create_pledge` and `get_recent_pledges` functions will be run in short lived client processes.
  first, we will have to start the `listen_loop` server process, and note its pid. That pid will then be used inside `create_pledge` function. `create_pledge` function will send a message to `listen_loop` server process with the name and amount. Inside `listen_loop`, we will store the incoming pledge data in a in memory state.
  for getting the recent pledges, we will again call the `listen_loop` server process from inside the `get_recent_pledges` client process. The pid that we noted will be used to send the message.
  """
  @process_name :pledge_server

  def start() do
    IO.puts "Starting the pledge server"
    spawn(fn -> listen_loop([]) end) |> Process.register(@process_name)
  end

  def create_pledge(name, amount) do
    # this part will run in a client process
    send @process_name, {self(), :create_pledge, {name, amount}}

    receive do {:response, id} -> id end
  end

  def get_recent_pledges() do
    send @process_name, {self(), :recent_pledges}

    receive do {:response, pledges} -> pledges end
    # note that receive is a blocking call
  end

  defp listen_loop(state) do
    # this part will run in a server process

    receive do
      {sender, :create_pledge, {name, amount}} ->
        {:ok, id} = send_pledge_to_external_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [ {name, amount} | most_recent_pledges]
        send sender, {:response, id}
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state)
    end
  end

  defp send_pledge_to_external_service(_name, _amount) do
    # simulate sending pledge to external service
    {:ok, System.unique_integer([:positive])}
  end
end