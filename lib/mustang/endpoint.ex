defmodule Mustang.Endpoint do
  use Phoenix.Endpoint, otp_app: :mustang

  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :mustang,
    only: ~w(css images js favicon.ico robots.txt)

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_mustang_key",
    signing_salt: "br7qLQFy",
    encryption_salt: "swYA0h5p"

  plug :router, Mustang.Router
end
