defmodule Elhex.PostalCode.CacheTest do
  use ExUnit.Case
  alias Elhex.PostalCode.Cache
  doctest Elhex

  test "get_and_set_distance" do
    p1 = "12345"
    p2 = "98764"
    distance = 99.98

    Cache.set_distance(p1, p2, distance)

    retrieved_distance = Cache.get_distance(p1, p2)

    assert retrieved_distance == distance
  end

end
