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


  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end

end