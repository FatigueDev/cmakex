defmodule Cmakex.Templates.Project do
  @moduledoc false

  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def project(project_name) do
        ~m"project(#{project_name})"n
      end

      def project(project_name, opts) do
        ~m"project(#{project_name}"

        if languages = Keyword.get(opts, :languages, false) do
          ~m" LANGUAGES "i
          ~m"#{Enum.map_join(languages, " ", fn lang -> "#{lang}" end)}"i
        end

        ~m")"ni
      end
    end
  end
end
