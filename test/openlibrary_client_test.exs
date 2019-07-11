defmodule OpenlibraryClientTest do
  use ExUnit.Case
  doctest OpenlibraryClient

  test "greets the world" do
    assert OpenlibraryClient.hello() == :world
  end
end
