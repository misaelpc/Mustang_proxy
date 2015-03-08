defmodule Mustang.Storage do

  def write_xml(catalog,file) do
    conf = Application.get_env(:mustang, :accounting_paths)
    {storage_path, _} = Keyword.pop(conf, :storage_path)

    path = storage_path <> catalog.type <> "/xml_attachment/" <> to_string(catalog.id) <> "/"
    zip_path = storage_path <> catalog.type <> "/zip_attachment/" <> to_string(catalog.id) <> "/"
    File.mkdir_p(path)
    xml_path = path <> catalog.attachment_name <> ".xml"
    File.write(xml_path ,file)
    %{xml_path: xml_path, zip_path: zip_path, file_name: catalog.attachment_name}
  end

  def generate_zip (attachment) do
    File.mkdir_p(attachment.zip_path)
    compress_path = attachment.zip_path <> attachment.file_name <> ".zip"
    :zip.create(to_char_list(compress_path), [to_char_list(attachment.xml_path)])
  end
    
end