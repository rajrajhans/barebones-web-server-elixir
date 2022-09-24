# A barebones toy web server written in Elixir

Recently, I started learning Elixir with the Pragmatic
Studio's [Developing with Elixir/OTP](https://pragmaticstudio.com/elixir) course. This is a simple web server that I
worked on while following along the course. The goal was to get

This toy web server covers:

1. Creating an http server in elixir using erlang's `gen_tcp` module.
2. Parsing the incoming http requests, routing them into corresponding functions, performing operations using different
   data types that Elixir provides and finally formatting and sending the response to the client. Using packages
   from `hex.pm` (here, we use the `Poison` package to perform JSON operations.)
3. Writing unit tests, doc tests in elixir.
4. Running code as separate processes asynchronously, implementing the actor model of concurrency of Elixir.
   Communicating between
   processes via messages.
5. Holding state in processes via GenServer and also an implementation of GenServer concept using low level processes.
    - (Check out
      the [pledges problem statement](lib/barebones/pledges/README.md) for an example of holding state in processes)

## Want to learn elixir?

Here are a few resources I'd recommend to get started:

### Resources

- The [Developing with Elixir/OTP](https://pragmaticstudio.com/elixir) course: great for people who are total beginners
  to elixir and
  the erlang
  ecosystem but already have worked with other languages.
- [Elixir School](https://elixirschool.com/en)
- [Intro To Elixir (from "Learn Elixir the Hard Way")](https://github.com/WhiteRookPL/learn-elixir-the-hard-way/blob/master/docs/introduction-to-elixir.md)

### Talks

- [Actor Model in Elixir – Michał Muskała – PartialConf 2017](https://www.youtube.com/watch?v=N5vJ1Y2j0uI): This talk
  gives a fantastic introduction of the Actor Model and Elixir. A must watch talk to understand how the Actor Model of
  concurrency is one of the greatest strengths of the Erlang ecosystem.

### Blog Posts

- [Comparing and contrasting the BEAM and JVM virtual machines](https://www.erlang-solutions.com/blog/optimising-for-concurrency-comparing-and-contrasting-the-beam-and-jvm-virtual-machines/) :
  understanding the whats and whys of the BEAM VM, on top of which Elixir / Erlang code runs. 