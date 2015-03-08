defmodule Mustang.Catalog do
  
  alias Mustang.Storage 
  alias Mustang.AccountCatalog
  alias Mustang.BalanceCatalog

  def save(xml,raw_file)do
    case Mustang.Xml.read(xml) do
      {:ok,result} -> is_account_catalog(result,raw_file)
                      is_balance_catalog(result,raw_file)
      {:error,error} -> {:error,error}
    end
  end


  def is_account_catalog(xml_catalog,raw_file) do
    case Mustang.Xml.query('/catalogocuentas:Catalogo/@RFC',xml_catalog) do
      [] -> []
      _ ->  
        AccountCatalog.save(xml_catalog) 
          |> Storage.write_xml(raw_file) 
          |> Storage.generate_zip
    end
  end

  def is_balance_catalog(xml_catalog, raw_file) do
    case Mustang.Xml.query('/BCE:Balanza/@RFC',xml_catalog) do
      [] -> []
      _ -> 
        BalanceCatalog.save(xml_catalog) 
        IO.puts "Nodo de balanzas encontrado se procede al guardado en base de datos"
    end
  end

end 