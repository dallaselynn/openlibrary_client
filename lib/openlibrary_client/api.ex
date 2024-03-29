defmodule OpenlibraryClient.Api do
  @moduledoc """
  Provides the http interface for calling the openlibrary service.
  """

  use HTTPoison.Base

  def process_request_url(url) do
    Application.get_env(:openlibrary_client, :base_url, "https://openlibrary.org") <> url
    |> URI.encode
  end

  def process_response_body(body) do
    case Poison.decode(body) do
      {:ok, json_data} -> json_data
      _ -> body
    end
  end

  def process_request_headers(headers \\ []) do
    headers
    |> Keyword.put_new(:"Content-Type", "application/json")
    |> Keyword.put_new(:"Accept", "application/json")
  end

  def login(username, password) do
    body = Poison.encode!(%{"access" => username, "secret" => password})
    post!("/account/login", body, [])
  end

  # generic methods that work with multiple kinds of objects
  # object is the openlibrary object key not the olid, eg. '/books/OL1M'
  def history(object_key, params) do
    get("#{object_key}.json?m=history", params: params)
  end

  # query through the Query API.
  def query(query, options \\ []) do
    get("/query.json?#{query}", options: options)
  end

  # query by bibkey
  def get_by_bibkey(bibkey, value, details \\ false)
  def get_by_bibkey(bibkey, value, false) do
    get("/api/books.json?bibkeys=#{bibkey}:#{value}")
  end

  def get_by_bibkey(bibkey, value, true) do
    bibkeys = "#{bibkey}:#{value}"
    get("/api/books?bibkeys=#{bibkeys}&format=json&jscmd=data")
  end

  # TODO: update
end
