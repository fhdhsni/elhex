defmodule Elhex.PostalCode.Supervisor do
  use Supervisor
  alias Elhex.PostalCode.{Store, Navigator, Cache}
  
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(Store, []),
      worker(Navigator, []),
      worker(Cache, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
