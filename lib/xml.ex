defmodule Mustang.Xml do
  
  def read (xml) do
    try do
      {xml_document,_} = :xmerl_scan.string(xml)
      {:ok,xml_document}
    catch
      :exit, _ -> {:error,"xml invalid, can not be readed"}
    end
  end
  

  def query(xpath, xml) do
    case :xmerl_xpath.string(xpath, xml) do
      [result] -> elem(result, 8)
      [] -> []
    end
  end

  def query_multiple(xpath, xml) do
    case :xmerl_xpath.string(xpath, xml) do
      [head|tail] -> [head|tail]
      [] -> []
    end
  end
  

end