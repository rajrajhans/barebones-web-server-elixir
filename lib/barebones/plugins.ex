defmodule Barebones.Plugins do
  def rewrite_path( %{path: "/adds"<>num} = requestMap) do
    %{requestMap | path: "/add"<>num}
  end

  def rewrite_path(requestMap), do: requestMap

  def log(request), do: IO.inspect(request)
end