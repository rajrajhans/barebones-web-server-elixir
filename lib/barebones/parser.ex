defmodule Barebones.Parser do
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")

    params = parse_params(params_string)
    headers = parse_headers(header_lines)

    %Barebones.RequestMap{
      method: method,
      path: path,
      resp_body: "",
      status: "",
      params: params,
      headers: headers
    }
  end

  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_headers(list) do
    parse_headers(list, %{})
  end

  def parse_headers([head | tail], acc) do
    [key, val] = String.split(head, ": ")
    acc = Map.put(acc, key, val)
    parse_headers(tail, acc)
  end

  def parse_headers([], acc), do: acc
end
