defmodule Mustang.Repo do
  use Ecto.Repo,
    adapter: Tds.Ecto,
    otp_app: :mustang

end