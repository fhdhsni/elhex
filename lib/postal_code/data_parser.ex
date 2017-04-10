defmodule Elhex.PostalCode.DataParser do
  @postal_code_filepath "data/2016_Gaz_zcta_national.txt"

  def parse_data do
    File.read!(@postal_code_filepath)
    |> String.trim
    |> String.split("\n") 
    |> (fn [_header | data_rows] -> data_rows end).()
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.map(&parse_data_column(&1))
    |> Stream.map(&format_row(&1))
    |> Enum.into(%{})
  end

  defp format_row([postal_code, latitude, longitude]) do
    {postal_code, {String.to_float(latitude), String.to_float(longitude)}}
  end

  defp parse_data_column([postal_code, _, _, _, _, latitude, longitude]) do
    [postal_code, latitude, longitude]
    |> Enum.map(&String.trim(&1))
  end
end
