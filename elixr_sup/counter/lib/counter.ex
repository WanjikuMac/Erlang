defmodule Counter do
  @moduledoc """
  Documentation for `Counter`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Counter.hello()
      :world

  """
  def count(acc) do
    Counter.Core.inc(acc)
  end
end
