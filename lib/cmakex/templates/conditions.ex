defmodule Cmakex.Templates.Conditions do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.ETS.RuntimeConfig

  # defmacro __using__(_) do
  #   quote do
  def cond_if(condition) do
    append_line("if(#{condition})")
    increment_depth()
  end

  def cond_else do
    decrement_depth()
    append_line("else()")
    increment_depth()
  end

  def cond_elseif(condition) do
    decrement_depth()
    append_line("elseif(#{condition})")
    increment_depth()
  end

  def cond_endif do
    decrement_depth()
    append_line("endif()")
  end

  #   end
  # end
end
