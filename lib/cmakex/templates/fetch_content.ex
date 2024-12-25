defmodule Cmakex.Templates.FetchContent do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def include_fetch_content, do: append_line("include(FetchContent)")

  def fetch_content_make_available(target) do
    append_line("FetchContent_MakeAvailable(#{target})")
  end

  def fetch_content_declare(target, options) do
    append_line_with_args("FetchContent_Declare", target, options)
  end

  #   end
  # end
end
