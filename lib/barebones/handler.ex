defmodule Barebones.Handler do
  @moduledoc "Handles HTTP requests."
  @pages_path Path.expand("../../pages", __DIR__)
  import Barebones.Plugins, only: [rewrite_path: 1, log: 1]
  import Barebones.Parser, only: [parse: 1]
  alias Barebones.RequestMap
  alias Barebones.BearController
  alias Barebones.Pledges.PledgeController

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

  def route(requestMap, "POST", "/hello") do
    %RequestMap{requestMap | resp_body: "Hello, #{requestMap.params["name"]}, the #{requestMap.params["type"]}", status: 200}
  end

  def route(requestMap, "GET", "/hey") do
    %RequestMap{requestMap | resp_body: "Beers, Beets, Star Wars", status: 200}
  end

  def route(requestMap, "GET", "/add/" <> num1  ) do
    %RequestMap{requestMap | resp_body: "Hear, ye #{String.to_integer(num1)+2}", status: 200}
  end

  def route(requestMap, "GET", "/bear") do
    BearController.index(requestMap)
  end

  def route(requestMap, "GET", "/api/bears") do
    Barebones.Api.BearController.index(requestMap)
  end

  def route(requestMap, "GET", "/bear/" <> id) do
    BearController.get_bear(requestMap, id)
  end

  def route(requestMap, "GET", "/about") do
    case File.read(@pages_path |> Path.join("about.html")) do
      {:ok, content} -> %RequestMap{requestMap | resp_body: content, status: 200}
      {:error, :enoent} -> %RequestMap{requestMap | resp_body: "File not found ", status: 404}
      {:error, reason} -> %RequestMap{requestMap | resp_body: "File error: #{reason}", status: 500}
    end
  end

  def route(requestMap, "GET", "/hibernate/" <> time) do
    time |> String.to_integer |> :timer.sleep
    %RequestMap{requestMap | resp_body: "Awake", status: 200}
  end

  def route(requestMap, "GET", "/bear-coordinates") do

    %RequestMap{requestMap | resp_body: Barebones.BearData.get_bear_coordinates(), status: 200}
  end

  def route(requestMap, "GET", "/pledges") do
    PledgeController.get(requestMap)
  end

  def route(requestMap, "POST", "/pledges") do
    PledgeController.create(requestMap)
  end

  def route(requestMap, _method, path) do
    %RequestMap{requestMap | resp_body: "404: #{path} Not found", status: 404}
  end

  def format_response(requestMap) do
    """
    HTTP/1.1 #{RequestMap.make_status(requestMap)}\r
    Content-Type: #{requestMap.resp_content_type}\r
    Content-Length: #{String.length(requestMap.resp_body)}\r
    \r
    #{requestMap.resp_body}
    """
  end
end
