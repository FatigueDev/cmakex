defmodule Cmakex.Cmake do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.ETS.RuntimeConfig

  require Cmakex.Templates.Function
  alias Cmakex.Templates.ErlNif
  alias Cmakex.Templates.Generic

  defmacro cmake([boilerplate: boilerplate] \\ [boilerplate: true], block) do
    block_id = "block_#{Path.basename(__CALLER__.file, ".cmake.exs")}_#{__CALLER__.line}"
    comments = get_comments(block_id)

    ast =
      block
      |> get_elements_in_block()
      |> insert_comments(comments)
      |> replace_elixir_ast_with_valid_cmake()
      |> insert_newlines()

    dbg(ast)

    quote generated: true, file: __CALLER__.file, line: __CALLER__.line do
      if unquote(boilerplate) do
        Generic.cmake_minimum_required()
        Generic.stamp_default_env()
        unquote({:__block__, [line: 1], ast})
        ErlNif.add_erts_to_target(Path.basename(__ENV__.file, ".cmake.exs"))
      else
        unquote({:__block__, [line: 1], ast})
      end
    end
  end

  defp get_elements_in_block(block) do
    List.first(block)
    |> elem(1)
    |> case do
      {:__block__, [line: 1], elements} -> elements
      element -> [element]
    end
  end

  defp insert_comments(expanded_block, comments) when is_list(comments) do
    Enum.map(comments, &to_comment/1)
    |> Enum.concat(expanded_block)
    |> Enum.sort_by(fn element ->
      Keyword.get(elem(element, 1), :line)
    end)
  end

  defp replace_elixir_ast_with_valid_cmake(quoted) do
    Stream.transform(quoted, [], fn el, acc ->
      # nested_value =
      #   if is_tuple(elem(el, 0)) do
      #     elem(el, 0)
      #   else
      #     false
      #   end

      {[parse_call(el)], acc}

      # if nested_value do
      #   {[nested_value], acc}
      # else
      #   {[el], acc}
      # end

      # cond do
      #   elem(el, 0) == := ->
      #     dbg(el)
      #     dbg(elem(Enum.at(elem(el, 2), 1), 0))
      #     {[el], acc}

      #   elem(nested_value, 0) == :. ->
      #     # dbg(el)

      #     function_name = elem(List.first(elem(nested_value, 2)), 0)
      #     function_args = elem(el, 2)

      #     result =
      #       quote line: elem(nested_value, 1)[:line] do
      #         function_call(unquote(to_string(function_name)), unquote(function_args))
      #       end

      #     {[result], acc}

      #   # elem(el, 0) == := ->
      #   #   {[:assignment_op], acc}

      #   # elem(el, 0) == :if ->
      #   #   {[:if_statement], acc}

      #   true ->
      #     {[el], acc}

      #     # elem(, 0) == :. ->
      #     #   {[:function_call], acc}

      #     # true ->
      #     #   {[el], acc}
      # end
    end)
    |> Stream.filter(fn el -> el != nil end)
    |> Enum.to_list()
  end

  #   {:=, [end_of_expression: [newlines: 2, line: 8], line: 6],
  #  [
  #    {:my_func, [line: 6], nil},
  #    {:fn, [closing: [line: 8], line: 6],
  #     [
  #       {:->, [newlines: 1, line: 6],
  #        [
  #          [{:left, [line: 6], nil}, {:right, [line: 6], nil}],
  #          {:message,
  #           [
  #             end_of_expression: [newlines: 1, line: 7],
  #             closing: [line: 7],
  #             line: 7
  #           ],
  #           [
  #             {:<<>>, [delimiter: "\"", line: 7],
  #              [
  #                {:"::", [line: 7],
  #                 [
  #                   {{:., [line: 7], [Kernel, :to_string]},
  #                    [from_interpolation: true, closing: [line: 7], line: 7],
  #                    [
  #                      {:+, [line: 7],
  #                       [{:left, [line: 7], nil}, {:right, [line: 7], nil}]}
  #                    ]},
  #                   {:binary, [line: 7], nil}
  #                 ]}
  #              ]}
  #           ]}
  #        ]}
  #     ]}
  #  ]}

  defp parse_call(
         {:=, meta, [{variable, [line: line], nil}, assignment_args] = assignment} =
           el
       ) do
    case assignment do
      {:=, meta, [{variable_name, [line: var_line], nil}, assignment]} ->
        quote line: var_line do
          message("Assignment")
          # function(
          #   {unquote(to_string(variable_name)), [line: unquote(var_line)], []},
          #   unquote(func)
          # )
        end

      [{variable_name, [line: var_line], _} = var, {:fn, fn_meta, fn_args} = func] = function_ast ->
        # dbg(variable_name)
        # dbg(func)

        # dbg(function_ast)
        [{_, _, [args, expression]}] = fn_args
        # dbg(args)
        # dbg(body)

        # meta_args =
        #   quote bind_quoted: [args: args], unquote: false do
        #   end
        #   |> dbg

        vars =
          Enum.map(args, fn arg ->
            # {elem(arg, 0), [line: line], Cmakex.Cmake}
            quote do
              var!(unquote(arg)) = nil
            end
          end)

        # expression = replace_elixir_ast_with_valid_cmake([expression]) |> dbg
        dbg(args)

        # args =
        #   Enum.map(args, fn arg ->
        #     elem(arg, 0)
        #   end)

        {:__block__, [line: line],
         [
           #  args,
           quote context: Cmakex.Cmake do
             #  Cmakex.Templates.Function.function(
             #    unquote(variable_name),
             #    unquote(args),
             #    unquote(expression)
             #  )

             #  unquote(vars)
             unquote(args)

             append_line(
               "function(#{unquote(variable_name)} #{Enum.map_join(unquote(args), " ", fn arg -> "#{arg}" end)})"
             )

             increment_depth()

             unquote(expression)

             decrement_depth()

             append_line("endfunction(#{unquote(variable_name)})")
           end
         ]}

      # with_updated_meta(line, 1)

      # quote line: var_line, bind_quoted: [el: el] do
      #   var!(unquote_splicing(args))
      #   dbg(left)
      #   # function(el)
      # end
      # |> dbg

      _ ->
        nil
    end

    # if {:fn, meta, args} = assignment do
    #   dbg("Is a function assignment")
    # else
    #   quote line: line do
    #     message(unquote(variable))
    #   end
    # end

    # if Enum.any?(el, fn {key, _, _} -> key == :fn end) do
    #   dbg("Has function call")
    # else
    #   "blah"
    # end

    # if elem(Enum.at(args, 1), 0) == :fn do
    #   "It's a function"
    # else
    #   "Not a function"
    # end

    # dbg("Hit parse call with func / block")
    # quote line: line do
    # end
    # "Hit"
  end

  defp parse_call(
         {{:., [line: call_line], [{function_name, [line: function_line], _}]},
          [
            end_of_expression: [newlines: 1, line: _],
            closing: [line: _],
            line: function_line
          ], function_args} = el
       ) do
    quote line: call_line do
      function_call(unquote(to_string(function_name)), unquote(function_args))
    end
  end

  defp parse_call({key, meta, args} = el), do: el

  # defp parse_call({:=, meta, args}) do
  #   dbg("Is assignment")
  # end

  # defp parse_call({:fn, meta, args}) do
  #   dbg("Is assignment")
  # end

  # defp parse_call({:->, meta, args}) do
  #   dbg("Is anonymous function")
  # end

  defp with_updated_meta(quoted, line, newlines) do
    quoted
    |> Macro.update_meta(&Keyword.put(&1, :closing, line: line))
    |> Macro.update_meta(&Keyword.put(&1, :end_of_expression, newlines: newlines, line: line))
  end

  defp to_comment(%{
         line: line,
         text: text,
         column: _,
         next_eol_count: newlines,
         previous_eol_count: _
       }) do
    quote line: line do
      append_line(unquote(text))
    end
    |> with_updated_meta(line, newlines)
  end

  defp insert_newlines(expanded_block) do
    Enum.reduce_while(expanded_block, [], fn element, acc ->
      current_index =
        Enum.find_index(expanded_block, fn el ->
          element == el
        end)

      # dbg(element)

      add_newline_if_line_difference_exceeded(expanded_block, element, current_index, acc)
    end)
    |> Enum.concat(expanded_block)
    |> Enum.sort_by(fn element ->
      Keyword.get(elem(element, 1), :line)
    end)
  end

  defp add_newline_if_line_difference_exceeded(expanded_block, element, current_index, acc) do
    case Enum.at(expanded_block, current_index + 1, nil) do
      nil ->
        {:halt, acc}

      next ->
        if line_difference(next, element) > 1 and Macro.classify_atom(elem(next, 0)) != :unquoted do
          line = elem(element, 1)[:line] + 1

          newline_ast =
            quote line: line, unquote: false do
              append_line()
            end
            |> with_updated_meta(line, 1)

          {:cont, [newline_ast | acc]}
        else
          {:cont, acc}
        end
    end
  end

  defp line_difference(left, right) do
    Keyword.get(elem(left, 1), :line) -
      Keyword.get(elem(right, 1), :closing, line: Keyword.get(elem(right, 1), :line))[:line]
  end
end
