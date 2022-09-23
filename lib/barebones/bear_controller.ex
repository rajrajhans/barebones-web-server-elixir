defmodule Barebones.BearController do
  @moduledoc "Module to handle the example 'Bear' resource"

  alias Barebones.BearData
  @templates_path Path.expand("../../templates", __DIR__)

  def index(requestMap) do
    bears = BearData.list_bears()
    html = @templates_path |> Path.join("index.eex") |> EEx.eval_file(bears: bears)

    %{requestMap |
      status: 200,
      resp_body: html
    }
  end

  def get_bear(requestMap, id) do
    bear = BearData.find_bear(id)

    if bear do
      %{requestMap |
        status: 200,
        resp_body: @templates_path |> Path.join("show.eex") |> EEx.eval_file(bear: bear)
      }
    else
      %{requestMap | status: 404, resp_body: "<h1>Could not find bear</h1>"}
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
