defmodule Cmakex.ETS.RuntimeConfig do
  @moduledoc false

  use Cmakex.ETS.Template

  def create_table,
    do: create_table([:named_table, :ordered_set])

  defp create_table(opts) do
    super(opts)
    insert({:depth, 0})
    insert({:current_line, 0})
    insert({:comments, []})
  end

  def clear_table do
    :ets.update_element(__MODULE__, :depth, {2, 0})
    :ets.update_element(__MODULE__, :current_line, {2, 0})
    :ets.update_element(__MODULE__, :comments, {2, 0})
  end

  def get_depth, do: lookup(:depth)
  def get_line, do: lookup(:current_line)

  def increment_depth, do: update_counter(:depth, 1)
  def decrement_depth, do: update_counter(:depth, -1)

  def set_line(line_number), do: :ets.update_element(__MODULE__, :current_line, {2, line_number})

  def increment_line, do: update_counter(:current_line, 1)

  def get_comments(block_id) do
    lookup(:"#{block_id}")
    |> then(&if(&1 == [], do: [], else: elem(List.first(&1), 1)))
  end

  def set_comments(id, comments), do: insert({:"#{id}", comments})
end
