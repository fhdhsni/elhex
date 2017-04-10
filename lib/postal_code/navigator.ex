defmodule Elhex.PostalCode.Navigator do
  use GenServer
  alias :math, as: Math
  alias Elhex.PostalCode.{Store, Cache}

  @radius 3959
  
  def start_link do
    GenServer.start_link(__MODULE__, [], name: :postal_code_navigator)
  end

  def get_distance(from, to) do
    GenServer.call(:postal_code_navigator, {:get_distance, from, to})
  end

  def handle_call({:get_distance, from, to}, _from, state) do
    distance = do_get_distance(from, to)
    {:reply, distance, state}
  end

  defp do_get_distance(from, to) do
    from = format_postal_code(from)
    to = format_postal_code(to)

    case Cache.get_distance(from, to) do
      nil -> 
        {lat1, long1} = get_geolocation(from)
        {lat2, long2} = get_geolocation(to)

        distance = calculate_distance({lat1, long1}, {lat2, long2})
        Cache.set_distance(from, to, distance)
        distance
      distance -> distance
    end
  end

  defp get_geolocation(postal_code) do
    Store.get_geolocation(postal_code)
  end

  defp format_postal_code(postal_code) when is_binary(postal_code), do: postal_code
  defp format_postal_code(postal_code) when is_integer(postal_code) do
    postal_code
    |> Integer.to_string()
    |> format_postal_code()
  end

  defp format_postal_code(postal_code) do
    error = "unexpected argument `postal_code`, received #{inspect postal_code}"
    raise ArgumentError, error
  end

  defp calculate_distance({lat1, long1}, {lat2, long2}) do
    lat_diff = degree_to_radian(lat1 - lat2)
    long_diff = degree_to_radian(long1 - long2)

    lat1 = degree_to_radian(lat1)
    lat2 = degree_to_radian(lat2)

    cos_lat1 = Math.cos(lat1)
    cos_lat2 = Math.cos(lat2)
    
    sin_lat_diff_sq = Math.sin(lat_diff / 2) |> Math.pow(2)
    sin_long_diff_sq = Math.sin(long_diff / 2) |> Math.pow(2)

    a = sin_lat_diff_sq + (cos_lat1 * cos_lat2 * sin_long_diff_sq)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    @radius * c |> Float.round(2)
  end

  defp degree_to_radian(degree) do
    degree * (Math.pi / 180)
  end

end
