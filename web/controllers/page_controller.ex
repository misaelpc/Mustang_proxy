defmodule Mustang.PageController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    IO.inspect Mustang.Search.sample_query
    render conn, "index.html"
  end
end
