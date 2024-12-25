defmodule Cmakex.Templates.Add do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def add_executable(executable, sources) do
    append_inline_with_args("add_executable", executable, sources)
  end

  def add_library(target, opts) do
    append_inline_with_args("add_library", target, opts)
  end

  def add_subdirectory(path, opts) do
    append_inline_with_args("add_subdirectory", path, opts)
  end

  #   end
  # end
end
