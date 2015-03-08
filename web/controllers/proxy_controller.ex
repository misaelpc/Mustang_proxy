defmodule Mustang.ProxyController do
  use Phoenix.Controller

  plug :action

  
  def fordward(conn, _params) do
    {:ok, document, _conn_details} = Plug.Conn.read_body(conn)

    conf = Application.get_env(:mustang, :accounting_issue_service)
    {url, _} = Keyword.pop(conf, :issue_url)

    response = HTTPotion.post url, [body: :erlang.bitstring_to_list(document), headers: conn.req_headers]
    
    case response.status_code do
      200 ->  response.body |> :erlang.bitstring_to_list
                            |> Mustang.Catalog.save(response.body)
              conn |> put_status(200)
                   |> text response.body
      number -> IO.inspect response.body
              conn |> put_status(number)
                   |> text response.body
    end
    
  end

end