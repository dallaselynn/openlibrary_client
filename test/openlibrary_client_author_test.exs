defmodule OpenlibraryClientAuthorTest do
  use ExUnit.Case

  alias OpenlibraryClient.Author

  test "olid_from_author/1" do
    assert Author.olid_from_author(nil) == nil
    assert Author.olid_from_author(%{"key" => "/authors/OL39307A"}) == "OL39307A"
  end

  test "normalized_name/1" do
    assert Author.normalized_name(nil) == nil
    assert Author.normalized_name("  RONALD RayRuns  ") == "ronald rayruns"
  end

  test "validate/1" do
    assert Author.is_valid_name?("Danny Robby Jr. III esq.") == true
    assert Author.is_valid_name?("Commas, Not Allowed") == false
  end

  test "get_by_olid/1" do
    # Mark Twain
    {:ok, resp} = Author.get_by_olid("OL18319A")
    assert resp.status_code == 200
    assert resp.body["name"] == "Mark Twain"

    {:ok, resp} = Author.get_by_olid("OL18319B")
    assert resp.status_code == 404
  end

  test "get_olid_by_name/1" do
    assert Author.get_olid_by_name("Mark Twain") == "OL18319A"
    assert Author.get_olid_by_name("Arthur C. Dantustan") == nil
  end

  test "works/3" do
    {:ok, works} = Author.works("OL18319A")
    assert works.status_code == 200
    assert works.request_url == "https://openlibrary.org/authors/OL18319A/works.json?limit=50&offset=0"

    {:ok, works} = Author.works("OL18319A", 10, 2)
    assert works.request_url == "https://openlibrary.org/authors/OL18319A/works.json?limit=10&offset=2"
  end

  test "search/2" do
    {:ok, resp} = Author.search("Mark Twain")
    assert resp.request_url == "https://openlibrary.org/authors/_autocomplete?q=Mark%20Twain&limit=1"
    assert length(resp.body) == 1
  end
end
