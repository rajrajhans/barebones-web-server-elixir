defmodule Barebones.Pledges.PledgeController do
  alias Barebones.RequestMap
  alias Barebones.Pledges.PledgeServerRefactored

  def create(requestMap) do
    %{"name" => name, "amount" => amount} = requestMap.params

    PledgeServerRefactored.create_pledge(name, String.to_integer(amount))

    %RequestMap{requestMap | resp_body: "#{name} pledged #{amount}" , status: 200}
  end

  def get(requestMap) do
    recent_pledges = PledgeServerRefactored.get_recent_pledges()
    res = inspect recent_pledges
    %RequestMap{requestMap | resp_body: res, status: 200}
  end

  def total(requestMap) do
    total = PledgeServerRefactored.total_pledged()
    %RequestMap{requestMap | resp_body: "Total #{total} pledged so far!", status: 200}
  end
end