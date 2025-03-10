defmodule Cmakex.Templates.Add do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def add_executable(executable, sources) do
    append_inline_with_args("add_executable", to_string(executable), sources)
  end

  def add_library(target, opts) do
    append_inline_with_args("add_library", to_string(target), opts)
  end

  def add_subdirectory(path, opts) do
    append_inline_with_args("add_subdirectory", path, opts)
  end

  def add_compile_options(opts) do
    append_inline_with_args("add_compile_options", "", opts)
  end

  #   end
  # end
end
