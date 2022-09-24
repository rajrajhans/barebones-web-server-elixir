defmodule Barebones.Pledges.PledgeServer do
  def create_pledge(name, amount) do

  end

  def get_recent_pledges() do

  end

  def listen_loop(state) do
    IO.puts "\n Waiting for a message"

    receive do
      {:create_pledge, {name, amount}} ->
          # simulate sending pledge to external service
          :timer.sleep(1)

          new_state = [ {name, amount} | state]
          listen_loop(new_state)

      {pid, :recent_pledges} ->
          send pid, {:response, state}
          listen_loop(state)
    end
  end
end