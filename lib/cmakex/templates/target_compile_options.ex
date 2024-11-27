defmodule Cmakex.Templates.TargetCompileOptions do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def target_compile_options(target, before_or_after, opts) do
        ~m"target_compile_options(#{target} #{String.upcase(Atom.to_string(before_or_after))}"

        if public = Keyword.get(opts, :PUBLIC, false) do
          ~m" PUBLIC "
          ~m"#{Enum.map_join(public, " ", fn public_option -> "#{public_option}" end)}"
        end

        ~m")"n
      end
    end
  end
end
