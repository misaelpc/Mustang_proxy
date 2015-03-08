defmodule Mustang.SecurityClient do
  use Ecto.Model

  schema "security_clients" do
    field :rfc, :string
    field :business_name, :string
    field :taxation, :string
    field :enabled, :boolean
    field :security_token, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  def fetch (rfc) do
    query = from c in Mustang.SecurityClient,
          where: c.rfc == ^rfc,
         select: c
    [head|_] = Mustang.Repo.all(query)
    head
  end

end