defmodule OpenlibraryClientWorkTest do
  use ExUnit.Case

  alias OpenlibraryClient.Work

  describe "get_metadata/1" do
    test "get_metadata/1 isbn" do
      {:ok, m} = Work.get_metadata(:isbn, "9780747550303")
      assert m.request_url == "https://openlibrary.org/api/books.json?bibkeys=ISBN:9780747550303"
      assert Map.has_key?(m.body, "ISBN:9780747550303") == true
    end

    test "get_metadata/1 oclc" do
      {:ok, m} = Work.get_metadata(:oclc, "XXX")
      assert m.request_url == "https://openlibrary.org/api/books.json?bibkeys=OCLC:XXX"
    end

    test "get_metadata/1 lccn" do
      {:ok, m} = Work.get_metadata(:lccn, "XXX")
      assert m.request_url == "https://openlibrary.org/api/books.json?bibkeys=LCCN:XXX"
    end

    test "get_metadata/1 olid" do
      {:ok, m} = Work.get_metadata(:olid, "XXX")
      assert m.request_url == "https://openlibrary.org/api/books.json?bibkeys=OLID:XXX"
    end

    test "get_metadata/1 ocaid" do
      {:ok, m} = Work.get_metadata(:ocaid, "XXX")
      assert m.request_url == "https://openlibrary.org/api/books.json?bibkeys=OCAID:XXX"
    end
  end

  test "get_by_olid/1" do
    {:ok, w} = Work.get_by_olid("OL2677499W")
    assert w.request_url == "https://openlibrary.org/works/OL2677499W.json"
    assert w.body["key"] == "/works/OL2677499W"

    {:ok, w} = Work.get_by_olid("OL2677499X")
    assert w.status_code == 404
  end

  describe "get_by_isbn/1" do
    test "removes spaces and non-digits" do
      {:ok, w} = Work.get_by_isbn("  978-0812971811  ")
      assert w.request_url == "https://openlibrary.org/query.json?type=/type/edition&isbn_13=9780812971811"
      assert w.status_code == 200
    end

    test "queries 10 digit isbn" do
      {:ok, w} = Work.get_by_isbn("0812971817")
      assert w.request_url == "https://openlibrary.org/query.json?type=/type/edition&isbn_10=0812971817"
      assert w.status_code == 200
    end

    test "queries 13 digit isbn" do
      {:ok, w} = Work.get_by_isbn("9780812971811")
      assert w.request_url == "https://openlibrary.org/query.json?type=/type/edition&isbn_13=9780812971811"
      assert w.status_code == 200
    end

    test "returns nil for unknown isbn length" do
      {:error, nil} = Work.get_by_isbn("123456789")
    end
  end

  test "details_by_isbn/1" do
    {:ok, resp} = Work.details_by_isbn("9780812971811")
    assert resp.request_url == "https://openlibrary.org/api/books?bibkeys=ISBN:9780812971811&format=json&jscmd=data"
  end

  test "editions/3" do
    {:ok, resp} = Work.editions("OL546124W", 3, 0)
    assert resp.request_url == "https://openlibrary.org/works/OL546124W/editions.json?limit=3&offset=0"
    assert resp.status_code == 200
    assert length(resp.body["entries"]) > 0
  end

  test "canonical_title/1" do
    assert Work.canonical_title("The Autobiography of: Benjamin Franklin") == "the autobiography of benjamin franklin"
  end
end
