# refactored version of `pledge_server.ex` to separate the code that is generic and can be reused into
# a separate module called `GenericServer`.

defmodule Barebones.Pledges.GenericServer do
  # after this refactoring, this GenericServer module encapsulates all the generic code that's common to
  # all server processes. It relies on callback module to implement the application specific code in the
  # functions handle_call and handle_cast.

  def start(callback_module, initial_state, process_name) do
    spawn(fn -> listen_loop(initial_state, callback_module) end) |> Process.register(process_name)
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

  def listen_loop(state, callback_module) do
    # this part will run in a server process
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        # here, we dont need to respond to the client because it doesnt expect a response
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state, callback_module)
    end
  end
end

defmodule Barebones.Pledges.PledgeServerRefactored do
  @process_name :pledge_server
  alias Barebones.Pledges.GenericServer

  def start do
    IO.puts "starting pledge server"
    GenericServer.start(__MODULE__, [], @process_name)
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

  # server callbacks

  def handle_call(:total_pledged, state) do
    IO.puts "recieved in handle call"
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