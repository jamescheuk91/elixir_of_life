defmodule ElixirOfLife.PageController do
  use ElixirOfLife.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
