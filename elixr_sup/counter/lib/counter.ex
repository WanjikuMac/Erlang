defmodule Counter do
alias Counter.Boundary
alias Counter.Core

  def start_link(initial_count) do
    Boundary.start_link(Core.clear(initial_count))
  end

  def inc(counter) do
    Counter.Boundary.inc(counter)
  end

  def state(counter) do
    Counter.Boundary.state(counter)
  end
end
