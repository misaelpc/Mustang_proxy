defmodule Mustang.AccountCatalogNode do
  use Ecto.Model

  schema "accounting_account_nodes" do
    field :account_number, :string
    field :sub_account_of, :string
    field :group_code, :string
    field :level, :integer
    field :nature, :string
    field :description, :string
    field :created_at, :datetime
    field :updated_at, :datetime
    field :account_catalog_id, :integer
  end

end