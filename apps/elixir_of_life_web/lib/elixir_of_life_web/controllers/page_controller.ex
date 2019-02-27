defmodule ElixirOfLife.PageController do
  use ElixirOfLifeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
