defmodule Cmakex.Records.Line do
  @moduledoc false
  require Record
  Record.defrecord(:line, Line, line_number: 0, depth: 0, text: <<>>)
  @type t() :: record(:line, line_number: integer(), depth: integer(), text: binary())

  def line_number(line) when Record.is_record(line, Line), do: line(line, :line_number)

  def line_number(line, current_line: current_line)
      when Record.is_record(line, Line) and is_integer(current_line),
      do: line(line, line_number: current_line)

  def depth(line) when Record.is_record(line, Line), do: line(line, :depth)

  def depth(line, depth: depth) when Record.is_record(line, Line) and is_integer(depth),
    do: line(line, depth: depth)

  def text(line) when Record.is_record(line, Line), do: line(line, :text)

  def text(line, text: text) when Record.is_record(line, Line) and is_binary(text),
    do: line(line, text: text)
end
