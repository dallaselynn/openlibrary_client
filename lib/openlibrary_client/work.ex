defmodule OpenlibraryClient.Work do
  @moduledoc """
  Schemas for the wok/book type, which are conflated here, and maybe should be separated.
  """

  alias OpenlibraryClient.Api

  def get_by_olid(olid), do: Api.get!("/works/#{olid}.json")
  def get_by_lccn(lccn), do: Api.get!("type=/type/edition&lccn#{lccn}.json")
  def get_by_oclc(oclc), do: Api.get!("type=/type/edition&oclc#{oclc}.json")

  def get_by_isbn(isbn) do
    case String.length(isbn) do
      10 -> Api.get!("type=/type/edition&isbn_10=#{isbn}")
      13 -> Api.get!("type=/type/edition&isbn_13=#{isbn}")
      _ -> nil
    end
  end

  # TODO: the python library pulls out the 'entries' from the json and returns that.
  def editions(olid, limit \\ 10, offset \\ 0) do
    Api.get!("/works/#{olid}/editions.json?limit=#{limit}&offset=#{offset}")
  end

  @doc """
  Creates a new work along with a new edition.
  """
  def create() do
  end

  @doc """
  Creates a new book and returns an edition.
  """
  def create_book(
        title,
        author_name,
        author_key,
        publish_date,
        publisher,
        id_name,
        id_value,
        work_olid \\ nil
      ) do
    data = %{
      "title" => title,
      "author_name" => author_name,
      "author_key" => author_key,
      "publish_date" => publish_date,
      "publisher" => publisher,
      "id_name" => id_name,
      "id_value" => id_value,
      "_save" => ""
    }

    url = cond do
      is_nil(work_olid) -> "/books/add"
      true -> "/books/add?work=/works/#{work_olid}"
    end
    
    Api.post!(url, data)
  end

  @doc """
  Make book titles homogenous so they can be compared canonically.

  ## Examples

      iex> OpenlibraryClient.Book.canonical_title("The Autobiography of: Benjamin Franklin")
      "the autobiography of benjamin franklin"
  """
  def canonical_title(title) do
    title
    |> String.downcase()
    |> String.replace(~r/([^\s\w])+/, "")
  end
end
