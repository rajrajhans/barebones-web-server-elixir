defmodule Barebones.BearController do
  @moduledoc "Module to handle the example 'Bear' resource"

  alias Barebones.BearData

  def index(requestMap) do
    bears = BearData .list_bears()
    # todo -> return html from this list of bears
  end

  def get_bear(requestMap, %{"id" => id}) do
    %{requestMap | status: 200, resp_body: "Bear #{id}}"}
    # todo -> send back the bear details with id = id
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
