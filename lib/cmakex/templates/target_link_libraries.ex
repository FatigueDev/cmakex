defmodule Cmakex.Templates.TargetLinkLibraries do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def target_link_libraries(target, libraries) do
        ~m"target_link_libraries(#{target}"

        Enum.each(libraries, fn lib ->
          ~m" #{lib}"
        end)

        ~m")"n
      end
    end
  end
end
