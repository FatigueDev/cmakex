defmodule Cmakex.Templates.TargetIncludeDirectories do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def target_include_directories(target, before_or_after, opts) do
        ~m"target_include_directories(#{target} #{String.upcase(Atom.to_string(before_or_after))}"

        if public = Keyword.get(opts, :PUBLIC, false) do
          ~m" PUBLIC "i
          ~m"#{Enum.map_join(public, " ", fn public_option -> "#{public_option}" end)}"i
        end

        ~m")"ni
      end
    end
  end
end
