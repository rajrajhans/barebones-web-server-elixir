defmodule Barebones do
  use Application

  def start(_type, _args) do
    Barebones.TopSupervisor.start_link()
  end
end