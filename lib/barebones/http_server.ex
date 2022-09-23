defmodule Barebones.HttpServer do
  def server do
    {:ok, lSock} = :gen_tcp.listen(
      5678, [:binary, packet: 0, active: false])
    {:ok, sock} = :gen_tcp.accept(lSock)
    {:ok, bin} = :gen_tcp.recv(sock, 0)
    # send response & loop
    :ok = :gen_tcp.close(sock)
    bin
  end
end