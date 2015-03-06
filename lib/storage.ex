defmodule Mustang.Storage do

  def write_xml(catalog,file) do
    IO.inspect catalog
    File.write("catalog.xml",file)
  end 

  def generate_zip do
    :zip.create('compress.zip', ['catalog.xml'])
  end
  
end