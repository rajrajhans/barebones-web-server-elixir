defmodule Barebones.TopSupervisor do
  use Supervisor

  def start_link do
    IO.puts "starting top supervisor"
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Barebones.ServicesSupervisor,
      Barebones.HttpServerKickStarter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end