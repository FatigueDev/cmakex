defmodule Cmakex.ETS.Line do
  @moduledoc false

  alias Cmakex.ETS.RuntimeConfig
  alias Cmakex.Records.Line

  use Cmakex.ETS.Template
  require Cmakex.Records.Line

  def create_table, do: create_table([:named_table, :duplicate_bag])

  defp create_table(opts), do: super(opts)

  def append_line_with_args(function_name, target, args) do
    append_line(function_name <> "(")
    RuntimeConfig.increment_depth()
    append_line(target)
    append_line_arguments(args)
    RuntimeConfig.decrement_depth()
    append_line(")")
  end

  def append_inline_with_args(function_name, "", args) do
    append_inline(function_name <> "(")
    append_inline_arguments(args, " ")
    append_inline(")")
    RuntimeConfig.increment_line()
  end

  def append_inline_with_args(function_name, target, args) do
    append_inline(function_name <> "(" <> target <> " ")
    append_inline_arguments(args)
    append_inline(")")
    RuntimeConfig.increment_line()
  end

  def append_line do
    Line.line()
    |> Line.line_number(RuntimeConfig.get_line())
    |> Cmakex.ETS.Line.insert()

    RuntimeConfig.increment_line()
  end

  def append_line(value) when is_atom(value) do
    append_line(to_string(value))
  end

  def append_line({key, value}) do
    append_line("#{to_string(key)} #{to_string(value)}")
  end

  def append_line(value) do
    Line.line(text: value)
    |> Line.depth(RuntimeConfig.get_depth())
    |> Line.line_number(RuntimeConfig.get_line())
    |> Cmakex.ETS.Line.insert()

    RuntimeConfig.increment_line()
  end

  def append_inline(value) when is_atom(value), do: append_inline(to_string(value))

  def append_inline(value) do
    Line.line(text: value)
    |> Line.depth(RuntimeConfig.get_depth())
    |> Line.line_number(RuntimeConfig.get_line())
    |> Cmakex.ETS.Line.insert()
  end

  def append_line_arguments(arguments, separator \\ " ") do
    Enum.each(arguments, fn arg ->
      case arg do
        {key, value} ->
          append_line("#{key}#{separator}#{value}")

        value ->
          append_line("#{value}")
      end
    end)
  end

  def append_inline_arguments(
        arguments,
        # ,
        separator \\ " "
        # [prepend: prepend, append: append] \\ [prepend: true, append: false]
      ) do
    Enum.each(arguments, fn arg ->
      # dbg(List.first(arguments))
      # dbg(arg)
      # dbg(prepend)

      # if List.first(arguments) != arg, do: append_inline(separator)

      case arg do
        {key, value} ->
          append_inline("#{key}#{separator}#{value}")

        value ->
          append_inline("#{value}")
      end

      if List.last(arguments) != arg, do: append_inline(separator)
    end)
  end

  # def append_inline_arguments_no_prepended_separator(arguments, separator \\ " ") do
  #   Enum.each(arguments, fn arg ->
  #     case arg do
  #       {key, value} ->
  #         append_inline("#{key}#{separator}#{value}")

  #       value ->
  #         append_inline("#{value}")
  #     end
  #   end)
  # end

  # def append_inline_arguments(arguments, separator \\ " ") do
  #   Enum.each(arguments, fn arg ->
  #     case arg do
  #       {key, value} ->
  #         append_inline("#{separator}#{key}#{separator}#{value}")

  #       value ->
  #         append_inline("#{separator}#{value}")
  #     end
  #   end)
  # end

  def transform_line_records(transform_function) do
    to_list()
    |> Stream.chunk_by(fn {Line, line_number, _, _} -> line_number end)
    |> Stream.map(fn el -> transform_function.(el) end)
    |> Enum.to_list()
  end

  def line_records_to_string do
    chunked =
      to_list()
      |> Enum.chunk_by(fn line -> Line.line(line, :line_number) end)

    for chunk <- chunked do
      Enum.map_join(chunk, "", fn lr ->
        depth_string =
          if Line.line(lr, :depth) > 0 do
            for _ <- 1..Line.line(lr, :depth) do
              "\t"
            end
            |> Enum.join()
          else
            ""
          end

        depth_string <> Line.line(lr, :text)
      end)
    end
    |> Enum.join("\n")

    # |> Enum.scan(fn line, next -> Line.line(line, :text) end)

    # to_list()
    # |> Enum.map(fn line ->
    #   depth = Line.line(line, :depth)
    #   line_number = Line.line(line, :line_number)

    #   "#{for _ <- 0..depth do
    #     "\t"
    #   end}" <> to_string(Line.line(line, :text))
    # end)
  end
end
