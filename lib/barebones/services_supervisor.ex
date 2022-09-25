defmodule Barebones.ServicesSupervisor do
  use Supervisor

  def start_link do
    IO.puts "starting the services supervisor"
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # here, we inform the supervisor about which children it needs to supervise
    children = [
      Barebones.Pledges.PledgeServerUsingGenServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end