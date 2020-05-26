defmodule Counter.Core do
  def clear(initial_value \\ 0) when is_integer(initial_value) do
    initial_value
  end

  def inc(acc) do
    acc + 1
  end
end
