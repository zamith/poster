defmodule Poster.PageController do
  use Poster.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
