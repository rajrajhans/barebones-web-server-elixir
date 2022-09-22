defmodule Barebones.BearController do
  @moduledoc "Module to handle the example 'Bear' resource"

  alias Barebones.BearData

  def index(requestMap) do
    bears = BearData.list_bears()
    html = "<ul>" <> Enum.reduce(bears, "", fn bear, acc -> acc <> "<li>#{bear.name}</li>" end) <> "</ul>"

    %{requestMap |
      status: 200,
      resp_body: html
    }
  end

  def get_bear(requestMap, id) do
    bear = BearData.find_bear(id)

    if bear do
      %{requestMap | status: 200, resp_body: "Bear #{id} is <h1>#{bear.name}</h1>, and is a #{bear.type} bear"}
    else
      %{requestMap | status: 404, resp_body: "Could not find bear"}
    end
  end

  def create(requestMap, %{"name" => name, "type" => type}) do
    %{ requestMap | status: 201, resp_body: "Created"}
    # todo -> create the bear
  end

  def hibernate_bear(requestMap, %{"id" => id}) do
    %{ requestMap | status: 200, resp_body: "OK"}
    # todo -> update the bear
  end
  
end
