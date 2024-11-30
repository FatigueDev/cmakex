defmodule Cmakex.Sigils do
  @moduledoc false

  import Cmakex.Process

  defmacro sigil_m(term, modifiers)

  # defmacro sigil_m({:<<>>, _line, _pieces} = contents, []) do
  #   quote do
  #     parts = unquote(get_parts(contents))
  #     Process.put(:cmake_string, get_proc() ++ [parts])
  #   end
  # end

  defmacro sigil_m({:<<>>, _line, _pieces} = contents, args) do
    quote do
      try_down_depth(unquote(args))

      parts =
        unquote(get_parts(contents))
        |> try_newline_to_parts(unquote(args))
        |> try_set_parts_depth(unquote(args))

      try_up_depth(unquote(args))

      Process.put(:cmake_string, get_proc() ++ [parts])
    end
  end

  def try_newline_to_parts(parts, args) do
    if ?n in args, do: parts <> "\n", else: parts
  end

  def try_set_parts_depth(parts, args) do
    if ?i in args, do: parts, else: set_parts_depth(parts)
  end

  def set_parts_depth(parts) do
    depth = get_depth()

    depth_string =
      if depth > 0 do
        for _ <- 1..depth, do: "\t"
      else
        []
      end
      |> Enum.join()

    depth_string <> parts
  end

  def try_up_depth(args) do
    if ?u in args, do: add_depth()
  end

  def try_down_depth(args) do
    if ?d in args, do: sub_depth()
  end

  # defmacro sigil_m({:<<>>, line, pieces}, [?+]) do
  #   quote do
  #   end
  # end

  defp get_parts({:<<>>, line, pieces}) do
    quote do
      unquote({:<<>>, line, unescape_tokens(pieces)})
    end
  end

  defp unescape_tokens(tokens) do
    :lists.map(
      fn token ->
        case is_binary(token) do
          true -> :elixir_interpolation.unescape_string(token)
          false -> token
        end
      end,
      tokens
    )
  end

  # defp unescape_tokens(tokens, unescape_map) do
  #   :lists.map(
  #     fn token ->
  #       case is_binary(token) do
  #         true -> :elixir_interpolation.unescape_string(token, unescape_map)
  #         false -> token
  #       end
  #     end,
  #     tokens
  #   )
  # end
end
