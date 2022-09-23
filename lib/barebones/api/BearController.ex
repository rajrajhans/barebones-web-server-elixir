defmodule Barebones.Api.BearController do
  def index(requestMap) do
    json = Barebones.BearData.list_bears()
           |> Poison.encode!

    %{requestMap | status: 200, resp_body: json, resp_content_type: "application/json"}
  end
end