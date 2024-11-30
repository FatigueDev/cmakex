defmodule Cmakex.Templates do
  @moduledoc false

  import Cmakex.Guards
  import Cmakex.Sigils

  use Cmakex.Templates.AddSubdirectory
  use Cmakex.Templates.AddLibrary
  use Cmakex.Templates.Function
  use Cmakex.Templates.Message
  use Cmakex.Templates.Project
  use Cmakex.Templates.TargetCompileOptions
  use Cmakex.Templates.TargetIncludeDirectories
  use Cmakex.Templates.TargetLinkLibraries

  def set(key, value) do
    ~m"set(#{key} #{value})"n
  end

  def unset(key) do
    ~m"unset(#{key})"n
  end

  def comment(text) do
    ~m"# #{text}"n
  end

  def newline do
    ~m""n
  end

  def newline(count) when is_non_negative_integer(count) do
    Enum.each(0..count, fn _ -> ~m""n end)
  end

  def add_executable(executable, sources) do
    ~m"add_executable(#{executable} #{Enum.join(sources, " ")})"n
  end

  # def print_current_cmakex_string() do
  #   IO.puts(get_proc_joined())
  # end

  # defp put_proc(string), do: Process.put(:cmake_string, get() ++ [string])
end
