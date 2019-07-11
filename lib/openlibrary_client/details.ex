defmodule OpenlibraryClient.Details do
  def find_by_isbn(key), do: find("ISBN", key)
  def find_by_lccn(key), do: find("LCCN", key)
  def find_by_oclc(key), do: find("OCLC", key)
  def find_by_olid(key), do: find("OLID", key)

  defp find(type, key) do
    params = %{
      "bibkeys" => "#{type}:#{key}",
      "format" => "json",
      "jscmd" => "data"
    }

    response = OpenlibraryClient.Api.get!("/api/books", [], params: params)

    case Map.has_key?(response.body, "#{type}:#{key}") do
      true ->
        response.body["#{type}:#{key}"]
      false -> nil
    end
  end
end
