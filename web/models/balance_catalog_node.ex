defmodule Mustang.BalanceCatalogNode do
  use Ecto.Model
  alias Mustang.Repo
  alias Mustang.BalanceCatalogNode 

  schema "accounting_balance_nodes" do
    field :account_number, :string
    field :opening_balance, :string
    field :debit, :string
    field :credit, :string
    field :closing_balance, :string
    field :created_at, :datetime
    field :updated_at, :datetime
    field :balance_id, :integer
  end

  def save(xml_doc, balance_id) do
    balance_node = %BalanceCatalogNode{account_number: to_string(Mustang.Xml.query('//@NumCta',xml_doc)),
                                      opening_balance: to_string(Mustang.Xml.query('//@SaldoIni',xml_doc)),
                                                debit: to_string(Mustang.Xml.query('//@Debe',xml_doc)),
                                               credit: to_string(Mustang.Xml.query('//@Haber',xml_doc)),
                                      closing_balance: to_string(Mustang.Xml.query('//@SaldoFin',xml_doc)),
                                           created_at: :calendar.universal_time(),
                                           updated_at: :calendar.universal_time(),
                                           balance_id: balance_id}
    Repo.insert(balance_node)
  end

end  