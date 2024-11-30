defmodule Cmakex.Process do
  @moduledoc false
  def get_proc_joined, do: get_proc() |> Enum.join()
  def get_proc, do: Process.get(:cmake_string, [])

  def get_depth, do: Process.get(:cmake_depth, 0)

  def add_depth do
    Process.put(:cmake_depth, get_depth() + 1)
  end

  def sub_depth do
    Process.put(:cmake_depth, get_depth() - 1)
  end
end
