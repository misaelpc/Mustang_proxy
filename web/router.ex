defmodule Mustang.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
  end

  scope "/", Mustang do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1/catalogo/firmar", Mustang do
    pipe_through :api
    post "/", ProxyController, :fordward
  end
end
