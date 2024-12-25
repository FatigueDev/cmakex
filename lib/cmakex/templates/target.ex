defmodule Cmakex.Templates.Target do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def target_compile_options(target, before_or_after, opts) do
    append_inline_with_args(
      "target_compile_options",
      "#{target} #{String.upcase(Atom.to_string(before_or_after))}",
      opts
    )
  end

  def target_include_directories(target, opts) do
    append_inline_with_args(
      "target_include_directories",
      "#{target}",
      opts
    )
  end

  def target_link_libraries(target, libraries) do
    append_inline_with_args("target_link_libraries", "#{target}", libraries)
  end

  #   end
  # end
end
