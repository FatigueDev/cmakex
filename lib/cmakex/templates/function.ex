defmodule Cmakex.Templates.Function do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.ETS.RuntimeConfig

  # defmacro __using__(_) do
  #   quote do
  defmacro function({name, _, args}, expression) do
    arg_length = length(args)
    arguments = Macro.generate_arguments(arg_length, __MODULE__)

    quote do
      append_line(
        "function(#{unquote(name)} #{Enum.map_join(unquote(args), " ", fn arg -> "#{arg}" end)})"
      )

      increment_depth()
      unquote(expression)
      decrement_depth()

      append_line("endfunction(#{unquote(name)})")

      fn unquote_splicing(arguments) ->
        append_line(
          "#{unquote(name)}(#{Enum.map_join(unquote(arguments), " ", fn arg -> "#{arg}" end)})"
        )
      end
    end
  end

  #   end
  # end
end
