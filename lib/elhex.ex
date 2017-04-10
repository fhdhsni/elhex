defmodule Elhex do
  use Application

  def start(_type, _args) do
    Elhex.Supervisor.start_link()
  end

end
