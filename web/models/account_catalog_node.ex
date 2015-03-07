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

  def save(xml_doc, catalog_id) do
    {level,_} = :string.to_integer(Mustang.Xml.query('//@Nivel',xml_doc))
    catalog_node = %Mustang.AccountCatalogNode{account_number: to_string(Mustang.Xml.query('//@NumCta',xml_doc)),
                                               sub_account_of: format_node(Mustang.Xml.query('//@SubCtaDe',xml_doc)),
                                                   group_code: to_string(Mustang.Xml.query('//@CodAgrup',xml_doc)),
                                                        level: level,
                                                       nature: to_string(Mustang.Xml.query('//@Natur',xml_doc)),
                                                  description: to_string(Mustang.Xml.query('//@Desc',xml_doc)),
                                                   created_at: :calendar.universal_time(),
                                                   updated_at: :calendar.universal_time(),
                                           account_catalog_id: catalog_id}
    Mustang.Repo.insert(catalog_node)
  end

  def format_node (value) do
    case value do
      [] -> nil
      value -> to_string(value)
    end
  end

end