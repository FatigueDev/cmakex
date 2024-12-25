defmodule Cmakex.ETS.RuntimeConfig do
  @moduledoc false

  use Cmakex.ETS.Template

  def create_table,
    do: create_table([:named_table, :ordered_set])

  defp create_table(opts) do
    super(opts)
    insert({:depth, 0})
    insert({:current_line, 0})
  end

  def clear_table do
    :ets.update_element(__MODULE__, :depth, {2, 0})
    :ets.update_element(__MODULE__, :current_line, {2, 0})
  end

  def get_depth, do: lookup(:depth)
  def get_line, do: lookup(:current_line)

  def increment_depth, do: update_counter(:depth, 1)
  def decrement_depth, do: update_counter(:depth, -1)

  def increment_line, do: update_counter(:current_line, 1)
end
