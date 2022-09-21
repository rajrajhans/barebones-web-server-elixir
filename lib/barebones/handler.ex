defmodule Barebones.Handler do
  def handler(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(request), do: IO.inspect(request)

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

  def route(requestMap) do
    route(requestMap, requestMap.method, requestMap.path)
  end

  def route(requestMap, "GET", "/hello") do
    %{requestMap | resp_body: "Bears, Beets, Battlestar Galactica", status: 200}
  end

  def route(requestMap, "GET", "/hey") do
    %{requestMap | resp_body: "Beers, Beefs, Star Wards", status: 200}
  end

  def route(requestMap, "GET", "/add/" <> num1  ) do
    %{requestMap | resp_body: "Hear, ye #{String.to_integer(num1)+2}", status: 200}
  end

  def route(requestMap, _method, path) do
    %{requestMap | resp_body: "404: #{path} Not found", status: 404}
  end

  def format_response(requestMap) do
    """
      HTTP/1.1 #{requestMap.status} #{status_reason(requestMap.status)}
      Content-Type: text/html
      Content-Length: #{String.length(requestMap.resp_body)}

      #{requestMap.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
    }[code]
  end
end

request = """
GET /add/2 HTTP/1.1
Host: example.in
User-Agent: HelloElixir/1.1
Accept: */*

"""

response = Barebones.Handler.handler(request)
IO.puts(response)
