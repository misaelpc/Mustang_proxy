defmodule Mustang.Catalog do
  
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
      _ ->  Mustang.AccountCatalog.save(xml_catalog) |> Mustang.Storage.write_xml(raw_file)
            Mustang.Storage.generate_zip()
            IO.puts "Nodo de cuentas encontrado se procede al guardado en base de datos"
    end
  end

  def is_balance_catalog(xml_catalog, raw_file) do
    case Mustang.Xml.query('/BCE:Balanza/@RFC',xml_catalog) do
      [] -> []
      _ -> IO.puts "Nodo de cuentas encontrado se procede al guardado en base de datos"
    end
  end

end 