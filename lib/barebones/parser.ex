defmodule Barebones.Parser do
  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")
    [request_line | header_lines] = String.split(top, "\r\n")
    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)

    %Barebones.RequestMap{
      method: method,
      path: path,
      resp_body: "",
      status: "",
      params: params,
      headers: headers
    }
  end

  @doc """
  Parses given query param string into corresponding map
  iex(1)> params_string = "name=Teddy&type=Black"
  iex(3)> Barebones.Parser.parse_params("application/x-www-form-urlencoded", params_string)
  %{"name" => "Teddy", "type" => "Black"}
  iex(3)> Barebones.Parser.parse_params("multipart/formdata", params_string)
  %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _) do
    IO.puts("Unsupported Content Type")
    %{}
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
