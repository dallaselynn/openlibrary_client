defmodule OpenlibraryClient.Base do
  @valid_identifiers  %{
    :olid => "olid",
    :oclc => "oclc",
    :isbn_10 => "isbn_10",
    :isbn_13 => "isbn_13",
    :isbns => "isbns",
    :lccn => "lccn",
    :goodreads => "goodreads",
    :librarything => "librarything"
  }

  @valid_ids %{
    :isbn_10 => "isbn_10",
    :isbn_13 => "isbn_13",
    :lccn => "lccn",
    :ocaid => "ocaid"
  }

end
