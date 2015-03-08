defmodule Mustang.BalanceCatalog do
  use Ecto.Model

  alias Mustang.Xml
  alias Mustang.BalanceCatalog
  alias Mustang.Repo
 
  schema "accounting_balances" do
    field :rfc, :string
    field :year, :integer
    field :month, :integer
    field :request_type, :string
    field :date_mod_bal, :string
    field :seal, :string
    field :certificate_number, :string
    field :certificate, :binary
    field :created_at, :datetime
    field :updated_at, :datetime
    field :xml_attachment, :string
    field :xml_url, :string
    field :zip_attachment, :string
    field :client_id, :integer
  end

  def save(xml_doc) do
    {year,_} = :string.to_integer(Mustang.Xml.query('/BCE:Balanza/@Anio',xml_doc))
    string_month = Mustang.Xml.query('/BCE:Balanza/@Mes',xml_doc)
    {month,_} = :string.to_integer(string_month)
    rfc = to_string(Mustang.Xml.query('/BCE:Balanza/@RFC',xml_doc))
    client = Mustang.SecurityClient.fetch(rfc)
    find_period(year,month,client.id) |> update_catalogs
    #nodes = Mustang.Xml.query_multiple('/catalogocuentas:Catalogo/catalogocuentas:Ctas',xml_doc)
    

    file_name = rfc <> to_string(year) <> to_string(string_month) <> "BC"

    catalog = %BalanceCatalog{rfc: rfc,
                                     year: year,
                                    month: month,
                                     seal: to_string(Xml.query('/BCE:Balanza/@Sello',xml_doc)),
                             request_type: to_string(Xml.query('/BCE:Balanza/@TipoEnvio',xml_doc)),
                             date_mod_bal: to_string(Xml.query('/BCE:Balanza/@FechaModBal',xml_doc)), 
                       certificate_number: to_string(Xml.query('/BCE:Balanza/@noCertificado',xml_doc)),
                              certificate: "test",
                               created_at: :calendar.universal_time(),
                               updated_at: :calendar.universal_time(),
                           xml_attachment: file_name <> ".xml",
                                  xml_url: "STORED FROM PROXY",
                           zip_attachment: file_name <> ".zip",
                                client_id: client.id}
    saved_catalog = Repo.insert(catalog)
    #add_accounts_nodes(nodes,saved_catalog.id)

    %{id: saved_catalog.id, type: "balance", attachment_name: file_name}
  end

  def find_period(year,month,client_id) do
    query = from c in BalanceCatalog,
          where: c.client_id == ^client_id and c.year == ^year and c.month == ^month,
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
    Repo.update(updated_catalog)
  end



end  