defmodule QlWeb.PageController do
  use QlWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # dbg(conn)
    render(conn, :home, layout: false)
  end
end
