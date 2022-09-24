defmodule Barebones.Pledges.PledgeController do
  alias Barebones.RequestMap

  def create(requestMap) do
    %{"name" => name, "amount" => amount} = requestMap.params
    %RequestMap{requestMap | resp_body: "#{name} pledged #{amount}" , status: 200}
  end

  def get(requestMap) do
    %RequestMap{requestMap | resp_body: "last three pledges here" , status: 200}
  end
end