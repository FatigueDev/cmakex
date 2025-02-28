defmodule Cmakex.Templates.Message do
  @moduledoc false
  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do

  # def message(type \\ :STATUS, {variable_name, _, _}) when is_atom(type) do
  #   append_line("message(#{String.upcase(message)})")
  # end
  def message(type \\ :STATUS, message)

  def message(type, message) when is_atom(type) and is_atom(message) do
    dbg(message)
    append_line("message(#{String.upcase(Atom.to_string(type))} ${#{message}})")
  end

  def message(type, message) when is_atom(type) and is_binary(message) do
    append_line("message(#{String.upcase(Atom.to_string(type))} \"#{message}\")")
  end

  #   end
  # end
end
