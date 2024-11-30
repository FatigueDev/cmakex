defmodule Cmakex.Templates.Function do
  @moduledoc false

  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      defmacro function({name, _, args}, expression) do
        arg_length = length(args)
        arguments = Macro.generate_arguments(arg_length, __MODULE__)

        quote do
          ~m"function(#{unquote(name)} #{Enum.map_join(unquote(args), " ", fn arg -> "#{arg}" end)})"nu
          unquote(expression)
          ~m"endfunction(#{unquote(name)})"nd

          fn unquote_splicing(arguments) ->
            ~m"#{unquote(name)}(#{Enum.map_join(unquote(arguments), " ", fn arg -> "#{arg}" end)})"n
          end
        end
      end
    end
  end
end
