defmodule Cmakex.Templates.Set do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def set(key, value), do: append_line("set(#{key} #{value})")
  def unset(key), do: append_line("unset(#{key})")

  def set_target_properties(target, opts) do
    append_inline_with_args("set_target_properties", target, opts)
  end

  #   end
  # end
end
