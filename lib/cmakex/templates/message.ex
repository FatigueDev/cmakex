defmodule Cmakex.Templates.Message do
  @moduledoc false
  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def message(type \\ :STATUS, message) when is_atom(type),
    do: append_line("message(#{String.upcase(Atom.to_string(type))} \"#{message}\")")

  #   end
  # end
end
