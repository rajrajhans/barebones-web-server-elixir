defmodule Barebones.Handler do
  @moduledoc "Handles HTTP requests."
  @pages_path Path.expand("../../pages", __DIR__)
  import Barebones.Plugins, only: [rewrite_path: 1, log: 1]
  import Barebones.Parser, only: [parse: 1]
  alias Barebones.RequestMap

  @doc "main handler function"
  def handler(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> format_response
  end

  def route(requestMap) do
    route(requestMap, requestMap.method, requestMap.path)
  end

  def route(requestMap, "GET", "/hello") do
    %RequestMap{requestMap | resp_body: "Bears, Beets, Battlestar Galactica", status: 200}
  end

  def route(requestMap, "GET", "/hey") do
    %RequestMap{requestMap | resp_body: "Beers, Beefs, Star Wards", status: 200}
  end

  def route(requestMap, "GET", "/add/" <> num1  ) do
    %RequestMap{requestMap | resp_body: "Hear, ye #{String.to_integer(num1)+2}", status: 200}
  end

  def route(requestMap, "GET", "/about") do
    case File.read(@pages_path |> Path.join("about.html")) do
      {:ok, content} -> %RequestMap{requestMap | resp_body: content, status: 200}
      {:error, :enoent} -> %RequestMap{requestMap | resp_body: "File not found ", status: 404}
      {:error, reason} -> %RequestMap{requestMap | resp_body: "File error: #{reason}", status: 500}
    end
  end

  def route(requestMap, _method, path) do
    %RequestMap{requestMap | resp_body: "404: #{path} Not found", status: 404}
  end

  def format_response(requestMap) do
    """
      HTTP/1.1 #{RequestMap.make_status(requestMap)}
      Content-Type: text/html
      Content-Length: #{String.length(requestMap.resp_body)}

      #{requestMap.resp_body}
    """
  end
end

request = """
GET /about HTTP/1.1
Host: example.in
User-Agent: HelloElixir/1.1
Accept: */*

"""

response = Barebones.Handler.handler(request)
IO.puts(response)
