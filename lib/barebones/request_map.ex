defmodule Barebones.RequestMap do
  defstruct method: "", path: "", resp_body: "", status: nil

  def make_status(%{status: status}=requestMap) do
    "#{status} #{status_reason(status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
    }[code]
  end
end
