defmodule Mustang.AccountCatalog do
  use Ecto.Model
  use Timex

  schema "accounting_account_catalogs" do
    field :rfc, :string
    field :year, :integer
    field :month, :integer
    field :seal, :string
    field :certificate_number, :string
    field :certificate, :string
    field :created_at, :datetime
    field :updated_at, :datetime
    field :xml_attachment, :string
    field :xml_url, :string
    field :zip_attachment, :string
    field :client_id, :integer
  end

  def save(xml_doc) do
    {year,_} = :string.to_integer(Mustang.Xml.query('/catalogocuentas:Catalogo/@Anio',xml_doc))
    {month,_} = :string.to_integer(Mustang.Xml.query('/catalogocuentas:Catalogo/@Mes',xml_doc))
    find_period(year,month) |> update_catalogs 
    rfc = to_string(Mustang.Xml.query('/catalogocuentas:Catalogo/@RFC',xml_doc))
    client = Mustang.SecurityClient.fetch(rfc)
    nodes = Mustang.Xml.query_multiple('/catalogocuentas:Catalogo/catalogocuentas:Ctas',xml_doc)
    

    catalog = %Mustang.AccountCatalog{rfc: rfc,
                                     year: year,
                                    month: month,
                                     seal: to_string(Mustang.Xml.query('/catalogocuentas:Catalogo/@Sello',xml_doc)),
                       certificate_number: to_string(Mustang.Xml.query('/catalogocuentas:Catalogo/@noCertificado',xml_doc)),
                              certificate: "certificado",
                               created_at: {{2015, 10, 12}, {0, 37, 14}},
                               updated_at: {{2015, 10, 12}, {0, 37, 14}},
                           xml_attachment: "Aqui la url",
                                  xml_url: "STORED FROM PROXY",
                           zip_attachment: "Aqui se tiene que generar el zip",
                                client_id: client.id}
    saved_catalog = Mustang.Repo.insert(catalog)
    add_accounts_nodes(nodes,saved_catalog.id)
    %{id: saved_catalog.id,rfc: saved_catalog.rfc, year: year, month: month}
  end

  def add_accounts_nodes([],_), do: []

  def add_accounts_nodes([head | tail],catalog_id) do
    [save_node(head,catalog_id) | add_accounts_nodes(tail,catalog_id)]
  end

  def save_node(node, catalog_id) do
    {level,_} = :string.to_integer(Mustang.Xml.query('//@Nivel',node))
    catalog_node = %Mustang.AccountCatalogNode{account_number: to_string(Mustang.Xml.query('//@NumCta',node)),
                                               sub_account_of: format_node(Mustang.Xml.query('//@SubCtaDe',node)),
                                                   group_code: to_string(Mustang.Xml.query('//@CodAgrup',node)),
                                                        level: level,
                                                       nature: to_string(Mustang.Xml.query('//@Natur',node)),
                                                  description: to_string(Mustang.Xml.query('//@Desc',node)),
                                                   created_at: {{2015, 10, 12}, {0, 37, 14}},
                                                   updated_at: {{2015, 10, 12}, {0, 37, 14}},
                                           account_catalog_id: catalog_id}
    Mustang.Repo.insert(catalog_node)
  end

  def format_node (value) do
    case value do
      [] -> nil
      value -> to_string(value)
    end
  end

  def find_period(year,month) do
    query = from c in Mustang.AccountCatalog,
          where: c.year == ^year and c.month == ^month,
         select: c
    [_|_] = Mustang.Repo.all(query)
  end

  def update_catalogs([]), do: []
    
  
  def update_catalogs([head | tail]) do
    [remove_seal(head)| update_catalogs(tail)]
  end

  def remove_seal (catalog) do
    updated_catalog = %{catalog | :seal => nil}
    Mustang.Repo.update(updated_catalog)
  end
  

end  