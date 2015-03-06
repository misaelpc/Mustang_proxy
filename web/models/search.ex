defmodule Mustang.Search do
  import Ecto.Query

  def sample_query do
    query = from w in Mustang.AccountCatalog,
          where: w.id == 1,
         select: w
    Mustang.Repo.all(query)
  end

end