defmodule Elhex.PostalCode.DataParserTest do
  use ExUnit.Case
  doctest Elhex

  alias Elhex.PostalCode.DataParser

  test ".parse_data" do
    {latitude, longitude} = 
      DataParser.parse_data()
      |> Map.get("94062")

    assert is_float(latitude)
    assert is_float(longitude)
  end
end
