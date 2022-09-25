defmodule Barebones.Pledges.GenericServer do
  def start(initial_state, process_name) do
    spawn(fn -> listen_loop(initial_state) end) |> Process.register(process_name)
  end

  def call(pid, message) do
    # sends the given message to given pid, waits for response, and returns it (synchronous)
    send pid, {:call, self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    # sends the given message to given pid and doesn't ex[ect a response (asynchronous)
    send pid, {:cast, message}
  end

  defp listen_loop(state) do
    # this part will run in a server process
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = Barebones.Pledges.PledgeServerRefactored.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state)
      {:cast, message} ->
        # here, we dont need to respond to the client because it doesnt expect a response
        new_state = Barebones.Pledges.PledgeServerRefactored.handle_cast(message, state)
        listen_loop(new_state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
  end
end

defmodule Barebones.Pledges.PledgeServerRefactored do
  @process_name :pledge_server
  alias Barebones.Pledges.GenericServer

  def start do
    IO.puts "starting pledge server"
    GenericServer.start([], @process_name)
  end

  def create_pledge(name, amount) do
    GenericServer.call @process_name, {:create_pledge, {name, amount}}
  end

  def get_recent_pledges() do
    GenericServer.call @process_name, :recent_pledges
  end

  def total_pledged() do
    GenericServer.call @process_name, :total_pledged
  end

  def clear() do
    GenericServer.cast @process_name, :clear
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, {name, amount}}, state) do
    {:ok, id} = send_pledge_to_external_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges]
    {id, new_state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  def send_pledge_to_external_service(_name, _amount) do
    # simulate sending pledge to external service
    {:ok, System.unique_integer([:positive])}
  end
end