defmodule Cmakex.Sigils do
  @moduledoc false

  import Cmakex.Process

  defmacro sigil_m(term, modifiers)

  defmacro sigil_m({:<<>>, line, pieces}, []) do
    quote do
      parts = unquote({:<<>>, line, unescape_tokens(pieces)})
      Process.put(:cmake_string, get_proc() ++ [parts])
    end
  end

  defmacro sigil_m({:<<>>, line, pieces}, [?n]) do
    quote do
      parts = unquote({:<<>>, line, unescape_tokens(pieces)})
      Process.put(:cmake_string, get_proc() ++ [parts <> "\n"])
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
