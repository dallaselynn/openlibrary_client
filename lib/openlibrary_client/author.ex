defmodule OpenlibraryClient.Author do
  @moduledoc """
  A book author and their identifier on a service.
  """
  @enforce_keys [:name]
  defstruct [
    :name,
    :olid,
    :bio,
    :birth_date,
    :death_date,
    :location,
    :fuller_name,
    :personal_name,
    :alternate_names,
    :title,
    :photos,
    :links,
    :remote_ids,
    :ol_revision
  ]

  alias OpenlibraryClient.Api


  def olid_from_author(nil), do: nil
  def olid_from_author(author), do: author["key"] |> String.split("/") |> List.last

  def normalized_name(nil), do: nil
  def normalized_name(name), do: name |> String.trim |> String.downcase

  @doc """
  Pre-validate the author before sending it to OpenLibrary

  ## Examples
  """
  def is_valid_name?(name) do
    not String.contains?(name, ",")
  end

  @doc """
  Get an author by olid
  """
  def get_by_olid(olid) do
    Api.get("/authors/#{olid}.json")
  end

  @doc """
  Uses the Authors auto-complete API to find OpenLibrary Authors with
  similar names. If any name is an exact match then return the
  matching author's 'key' (i.e. olid). Otherwise, return None.

  FIXME Warning: if there are multiple exact matches, (e.g. a common
  name like "Mike Smith" which may have multiple valid results), this
  presents a problem.

  Args:
    name (unicode) - name of an Author to search for within OpenLibrary

  Returns:
    olid (unicode) or nil

  """
  def get_olid_by_name(name) do
    normalized_name = normalized_name(name)

    case OpenlibraryClient.Author.search(name) do
      {:ok, resp} ->
        Enum.find(resp.body, fn x -> normalized_name(x["name"]) == normalized_name end)
        |> olid_from_author()
      _ -> nil
    end
  end

  @doc """
  Returns a list of OpenLibrary Works associated with an OpenLibrary Author.
  """
  def works(olid, limit \\ 50, offset \\ 0) do
    Api.get("/authors/#{olid}/works.json?limit=#{limit}&offset=#{offset}")
  end

  @doc """
  Finds a list of OpenLibrary authors with similar names to the
  search query using the Author auto-complete API.
  """
  def search(name, limit \\ 1) do
    Api.get("/authors/_autocomplete?q=#{name}&limit=#{limit}")
  end
end
