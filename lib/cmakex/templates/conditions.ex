defmodule Cmakex.Templates.Conditions do
  @moduledoc false

  # import Kernel, except: [if: 2, or: 2, end: 0]

  # import Cmakex.ETS.Line
  # import Cmakex.ETS.RuntimeConfig

  # def if(condition, clauses) do
  #   dbg(condition)
  #   append_line(condition)
  #   # IO.puts("#{condition} #{clauses}")
  # end

  # def if(condition, clauses) do
  #   append_line("if(#{condition})")
  #   increment_depth()
  # end

  # def elseif(left, right) do
  #   decrement_depth()
  #   append_line("else()")
  #   increment_depth()
  # end

  # def elseif(condition) do
  #   decrement_depth()
  #   append_line("elseif(#{condition})")
  #   increment_depth()
  # end

  # def _endif do
  #   decrement_depth()
  #   append_line("endif()")
  # end
end
