### Problem statement:

- A name and an amount will be sent to the server as a post request.
- Our server will forward the pledge data to an external API which will save it somewhere (we can just simulate it
  using `:timer.sleep`).
- However, we need to implement a GET pledges in our server which should send back the **last three** pledges that were
  created.
    - The last three pledges need to be stored in an **in memory cache** in the process.

![](diagram.png)

- For the low level process based implementation of this, check [pledge_server.ex](pledge_server.ex).
- Refactored version of the same that makes it more generic and similar to GenServer,
  check [pledge_server_refactored.ex](pledge_server_refactored.ex).
- Finally, check [pledge_server_using_genserve.ex](pledge_server_using_genserver.ex) for implementing this with
  GenServer.

### GenServer

- GenServer is a OTP behaviour module that implements a long lived process that can be used for keeping state, executing
  code asynchronously, etc.
- It abstracts away the common client server implementation that we would otherwise need to do using `send` `receive`
  etc.
- Using GenServer, we only need to implement the handler callback functions in our modules. It also provides us with
  tracing, error reporting and also fits into a supervision tree.

- You can implement an `init` function in your module to provide a initialising state for your genserver process. It
  receives a `state` as a arg and expects `{:ok, initial_state` as return val
- You can send messages to the genserver process by
    - `GenServer.call process_name, :message`
        - use call when you are expecting back a response
        - since we have to wait for the response to come back, this is a synchronous operation
        - implement `handle_call(:message, from, state)` in your module. `handle_call` functions will be called every
          time for `GenServer.call`
            - (you can implement multiple handle call fns for different patterns that you are sending for different :
              messages
        - return type for `handle_call` would be `{:reply, response, state}`, where response is the one that will be the
          response for the original `GenServer.call`, and state is the new state that you want to set in the genserver
          process.
    - `GenServer.cast process_name, :message`
        - use cast when you do not want any response back,
        - since we dont have to wait for the response, it wont block and operations will happen asynchronously.
        - implement `handle_cast(:message, state)` in your module. `handle_cast` functions will be called every time
          for `GenServer.cast`
        - return type for `handle_cast` would be `{:no_reply, state}`
- Any messages that the genserver receives that are not sent via `[Genserver.call](http://Genserver.call)`
  or `Genserver.cast` are handled by the `handle_info` function. (for ex if you send message using `Process.send`)
    - So if you want to do something asynchronously, you can implement `handle_info` function in your module.
    - Example: we want to fetch new state every 60 minutes from an external API.
        - To implement this, in our init function, we will do

            ```elixir
            def init(_state) do 
                initial_state = run_tasks_to_get_new_state()
                Process.send_after(self(), :refresh, :timer.minutes(60))
                {:ok, initial_state}
            
            # implementing the handle_info function
            def handle_info(:refresh, _state) do 
                IO.puts "refreshing the state"
                new_state = run_tasks_to_get_new_state()
                Process.send_after(self(), :refresh, :timer.minutes(60))
                {:noreply, new_state}
            ```