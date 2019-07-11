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

  @doc """
  Pre-validate the author before sending it to OpenLibrary

  ## Examples
  """
  def validate(author) do
    String.contains?(author.name, ",")
  end

  @doc """
  Get an author by olid
  """
  def get_by_olid(olid) do
    Api.get!("/authors/#{olid}.json")
  end

  @doc """
  Returns a list of OpenLibrary Works associated with an OpenLibrary Author.
  """
  def works(olid, limit \\ 50, offset \\ 0) do
    Api.get!("/authors/#{olid}/works.json?limit=#{limit}&offset=#{offset}")
  end

  @doc """
  Finds a list of OpenLibrary authors with similar names to the
  search query using the Author auto-complete API.
  """
  def search(name, limit \\ 1) do
    Api.get!("/authors/_autocomplete?q=#{name}&limit=#{limit}")
  end
end
