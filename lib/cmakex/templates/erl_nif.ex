defmodule Cmakex.Templates.ErlNif do
  @moduledoc false

  # import Cmakex.ETS.Line
  import Cmakex.Templates.Target
  import Cmakex.Templates.Environment

  # defmacro __using__(_) do
  #   quote do
  def add_erts_to_target(target),
    do: target_include_directories(target, [:PRIVATE, erts_include_dir()])

  #   end
  # end
end
