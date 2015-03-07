defmodule Mustang.AccountCatalog do
  use Ecto.Model
  use Timex

  alias Mustang.AccountCatalogNode

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
    
    IO.inspect to_string(Mustang.Xml.query('/catalogocuentas:Catalogo/@Certificado',xml_doc))

    file_name = rfc <> to_string(year) <> to_string(month) <> "CT"

    catalog = %Mustang.AccountCatalog{rfc: rfc,
                                     year: year,
                                    month: month,
                                     seal: to_string(Mustang.Xml.query('/catalogocuentas:Catalogo/@Sello',xml_doc)),
                       certificate_number: to_string(Mustang.Xml.query('/catalogocuentas:Catalogo/@noCertificado',xml_doc)),
                              certificate: "TEST",
                               created_at: :calendar.universal_time(),
                               updated_at: :calendar.universal_time(),
                           xml_attachment: file_name <> ".xml",
                                  xml_url: "STORED FROM PROXY",
                           zip_attachment: file_name <> ".zip",
                                client_id: client.id}
    saved_catalog = Mustang.Repo.insert(catalog)
    add_accounts_nodes(nodes,saved_catalog.id)

    %{id: saved_catalog.id, type: "account_catalog", attachment_name: file_name}
  end

  def add_accounts_nodes([],_), do: []

  def add_accounts_nodes([head | tail],catalog_id) do
    [AccountCatalogNode.save(head,catalog_id) | add_accounts_nodes(tail,catalog_id)]
  end

  def find_period(year,month) do
    query = from c in Mustang.AccountCatalog,
          where: c.year == ^year and c.month == ^month and not is_nil(c.seal),
         select: c
    case  Mustang.Repo.all(query) do
      [] ->
        []
      [head|tail] ->
        [head|tail]  
    end
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