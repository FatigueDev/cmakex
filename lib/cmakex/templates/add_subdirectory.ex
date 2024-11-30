defmodule Cmakex.Templates.AddSubdirectory do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def add_subdirectory(path, name), do: add_subdirectory(path, name, [])

      def add_subdirectory(path, name, opts) do
        ~m"add_subdirectory(#{path} #{name}"

        Enum.each(opts, fn opt ->
          ~m" #{String.upcase(Atom.to_string(opt))}"i
        end)

        ~m")"n
      end
    end
  end
end
