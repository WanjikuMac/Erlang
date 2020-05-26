defmodule Counter.Boundary do
  use GenServer
  alias Counter.Core

  def inc(counter) do
    GenServer.cast(counter, :inc)
  end

  def state(counter) do
    GenServer.call(counter, :state)
  end

  def start_link(default) when is_integer(default) do
    GenServer.start_link(__MODULE__, Core.clear(default))
  end

  def init(initial_number) when is_binary(initial_number) do
    {:ok, String.to_integer(initial_number)}
  rescue
    _e ->
      {:error, "Specify an integer or a string that converts to an integer"}
  end

  def init(initial_number) when is_integer(initial_number) do
    {:ok, initial_number}
  end

  def init(initial_number) do
    {:ok, initial_number}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:inc, number) do
    {:noreply, Core.inc(number)}
  end
end
