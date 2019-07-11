import Config

config :openlibrary_client,
  base_url: "https://openlibrary.org"

import_config "#{Mix.env()}.exs"
