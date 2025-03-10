defmodule Cmakex.Templates.Set do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def set(key, value) when is_binary(key) do
    append_line("set(#{key} #{value})")
  end

  def set(key, value) when is_atom(key) do
    case Macro.classify_atom(key) do
      :alias ->
        key = to_string(key) |> String.replace("Elixir.", "")
        append_line("set(#{to_string(key)} #{value})")

      _ ->
        append_line("set(#{key} #{value})")
    end
  end

  # def set(key, value), do: append_line("set(#{key} #{value})")
  def unset(key), do: append_line("unset(#{key})")

  def set_target_properties(target, opts) do
    append_inline_with_args("set_target_properties", target, opts)
  end

  #   end
  # end
end
