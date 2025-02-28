defmodule Cmakex.Templates.Function do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.ETS.RuntimeConfig

  # defmacro function({:=, _meta, [token, func]} = _assignment) do
  #   {function_name, _function_meta, nil} = token
  #   {_, _, [{:->, _, [args, expression]}]} = func

  #   quote context: Cmakex.Cmake,
  #         unquote: false,
  #         bind_quoted: [function_name: function_name, args: args, expression: expression] do
  #     append_line(
  #       "function(#{function_name} #{Enum.map_join(args, " ", fn arg -> "#{arg}" end)})"
  #     )

  #     increment_depth()
  #     expression
  #     decrement_depth()

  #     append_line("endfunction(#{function_name})")
  #   end
  # end

  # defmacro function(
  #            {:=, _meta,
  #             [
  #               {function_name, _meta, nil},
  #               {:fn, _meta, [{:->, _meta, [[args, expression]]}]}
  #             ]}
  #          ) do
  #   dbg(function_name)
  #   dbg(args)
  #   dbg(expression)
  # end

  # defmacro define_variable(variable_name, value) do
  #   quote do
  #     var!(left, Cmakex.Cmake) = unquote(value)
  #   end
  # end

  defmacro define_variables(args) do
    quote do
      for v <- unquote(args) do
        Macro.var(v, Cmakex.Cmake)
      end
    end
  end

  # defmacro function(name, args, expression) do
  #   quote do
  #     append_line(
  #       "function(#{unquote(name)} #{Enum.map_join(unquote(args), " ", fn arg -> "#{arg}" end)})"
  #     )

  #     increment_depth()

  #     # unquote(expression)

  #     decrement_depth()

  #     append_line("endfunction(#{unquote(name)})")
  #   end
  # end

  defmacro function_call(function_name, args) do
    quote do
      append_inline_with_args(unquote(function_name), "", unquote(args))
    end
  end

  # defmacro __using__(_) do
  #   quote do
  # defmacro function({name, _, args}, expression) do
  #   arg_length = length(args)
  #   arguments = Macro.generate_arguments(arg_length, __MODULE__)

  #   quote do
  #     append_line(
  #       "function(#{unquote(name)} #{Enum.map_join(unquote(args), " ", fn arg -> "#{arg}" end)})"
  #     )

  #     increment_depth()
  #     unquote(expression)
  #     decrement_depth()

  #     append_line("endfunction(#{unquote(name)})")

  #     fn unquote_splicing(arguments) ->
  #       append_line(
  #         "#{unquote(name)}(#{Enum.map_join(unquote(arguments), " ", fn arg -> "#{arg}" end)})"
  #       )
  #     end
  #   end
  # end

  #   end
  # end
end
