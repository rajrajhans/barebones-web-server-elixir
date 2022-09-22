defmodule Barebones.Parser do
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> Enum.map(fn x -> String.trim(x) end)
      |> List.first()
      |> String.split(" ")

    %{
      method: method,
      path: path,
      resp_body: "",
      status: ""
    }
  end
end
