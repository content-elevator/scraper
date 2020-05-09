defmodule ScraperWeb.Router do
  use ScraperWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ScraperWeb do
    pipe_through :api
  end
end
