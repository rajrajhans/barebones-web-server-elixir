defmodule Barebones.Pledges.PledgeServerUsingGenServer do
  @process_name :pledge_server

  use GenServer # this macro injects the default implementations of the callbacks into our module

  def start do
    IO.puts "starting pledge server"
    GenServer.start(__MODULE__, [], name: @process_name)
  end

  # for supervisor
  def start_link(_arg) do
    IO.puts "starting pledge server"
    GenServer.start_link(__MODULE__, [], name: @process_name)
  end

  def create_pledge(name, amount) do
    GenServer.call @process_name, {:create_pledge, {name, amount}}
  end

  def get_recent_pledges() do
    GenServer.call @process_name, :recent_pledges
  end

  def total_pledged() do
    GenServer.call @process_name, :total_pledged
  end

  def clear() do
    GenServer.cast @process_name, :clear
  end

  # server callbacks. GenServer expects the caller module to implement six callback functions

  def handle_call(:total_pledged, _from, state) do
    IO.puts "recieved in handle call"
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
    # reply indicates that the server needs to send back reply to client.
    # its going to reply with the second argument, and the third argument is the new state
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:create_pledge, _from, {name, amount}}, state) do
    {:ok, id} = send_pledge_to_external_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges]
    {:reply, id, new_state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, []}
  end

  def send_pledge_to_external_service(_name, _amount) do
    # simulate sending pledge to external service
    {:ok, System.unique_integer([:positive])}
  end
end