defmodule Cmakex.Process do
  @moduledoc false
  def get_proc_joined(), do: get_proc() |> Enum.join()
  def get_proc(), do: Process.get(:cmake_string, [])
end
