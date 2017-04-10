defmodule Elhex.PostalCode.NavigatorTest do
  use ExUnit.Case
  alias Elhex.PostalCode.Navigator
  doctest Elhex

  describe "get_distance" do
    test "postal code string" do
      distance = Navigator.get_distance("94062", "94104")
      assert is_float(distance)
    end

    test "postal code integer" do
      distance = Navigator.get_distance(94062, 94104)
      assert is_float(distance)
    end

    test "postal code mix of integer and string" do
      distance = Navigator.get_distance("94062", 94104)
      assert is_float(distance)
    end

    @tag :capture_log
    test "postal code unexpected format" do
      navigator_pid = Process.whereis(:postal_code_navigator)
      reference = Process.monitor(navigator_pid)
      catch_exit do
        Navigator.get_distance("94062", 94104.9876)
      end
      assert_received({:DOWN, ^reference, :process, ^navigator_pid, {%ArgumentError{}, _}})
    end
  end
end
