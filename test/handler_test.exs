defmodule HandlerTest do
  use ExUnit.Case

  import Barebones.Handler, only: [handler: 1]

  test "GET /bear" do
    request = """
    GET /bear HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handler(request)

    expected_response = "  HTTP/1.1 200 OK\n  Content-Type: text/html\n  Content-Length: 378\n\n  <h1>All of the bears</h1>\n\n<ul>\n   \n    <li>Teddy - Brown</li>\n    \n    <li>Smokey - Black</li>\n    \n    <li>Paddington - Brown</li>\n    \n    <li>Scarface - Grizzly</li>\n    \n    <li>Snow - Polar</li>\n    \n    <li>Brutus - Grizzly</li>\n    \n    <li>Rosie - Black</li>\n    \n    <li>Roscoe - Panda</li>\n    \n    <li>Iceman - Polar</li>\n    \n    <li>Kenai - Grizzly</li>\n    \n</ul>\n"

    IO.inspect(response)

    assert remove_whitespace(response) == remove_whitespace(expected_response)

  end


  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handler(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 635

    [{"type":"Brown","name":"Teddy","is_hibernating":true,"id":1},
     {"type":"Black","name":"Smokey","is_hibernating":false,"id":2},
     {"type":"Brown","name":"Paddington","is_hibernating":false,"id":3},
     {"type":"Grizzly","name":"Scarface","is_hibernating":true,"id":4},
     {"type":"Polar","name":"Snow","is_hibernating":false,"id":5},
     {"type":"Grizzly","name":"Brutus","is_hibernating":false,"id":6},
     {"type":"Black","name":"Rosie","is_hibernating":true,"id":7},
     {"type":"Panda","name":"Roscoe","is_hibernating":false,"id":8},
     {"type":"Polar","name":"Iceman","is_hibernating":true,"id":9},
     {"type":"Grizzly","name":"Kenai","is_hibernating":false,"id":10}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end



  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end

end