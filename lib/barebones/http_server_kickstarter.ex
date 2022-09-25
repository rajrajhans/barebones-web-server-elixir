# we want to make our HttpServer Module fault tolerant, meaning if it crashes, we want to create one more instance of that process.
# we will handle that in this KickStarter module using GenServer
defmodule Barebones.HttpServerKickStarter do
  use GenServer

  def start do
    IO.puts "Starting the kickstarter"
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # adding this flag because we dont want to crash the kickstarter process if http server process crashes
    # we are linking them below, so normal behaviour is that when one process crashes, other one is also sent an exit signal and it crashes as well
    # by specifying this flag, we are trapping the exit signal, when we get exit signal, genserver will call handle_info with the reason. then, we can spawn a new http server process in the appropriate handle info
    Process.flag(:trap_exit, true)
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  # this will be called when http server process crashes (because we are trapping exit in genserver init
  def handle_info({:EXIT, _server_pid, reason}, _state) do
    IO.puts "http server exited #{inspect reason}"
    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  def start_http_server do
    IO.puts "Starting the http server..."

    # linking the kickstarter process and http server process
    server_pid = spawn_link(fn -> Barebones.HttpServer.start(1232) end)
    Process.register(server_pid, :http_server)
    server_pid
  end
end

## Testing this
# start the kickstarter server
# get the http server pid via Porcess.whereis(:http_server)
# crash it using Process.exit(server_pid, :reason)
# check if both your processes are alive