defmodule TsBenchWeb.PageController do
  use TsBenchWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
