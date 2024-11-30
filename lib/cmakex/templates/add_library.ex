defmodule Cmakex.Templates.AddLibrary do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def add_library(target, type, files) do
        ~m"add_library(#{target} #{String.upcase(Atom.to_string(type))}"

        Enum.each(files, fn file ->
          ~m" #{file}"i
        end)

        ~m")"n
      end
    end
  end
end
