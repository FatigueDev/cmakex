defmodule Cmakex.Cmake do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.ETS.RuntimeConfig

  alias Cmakex.Templates.ErlNif
  alias Cmakex.Templates.Generic

  # defp get_block_id(file, line), do: "block_#{Path.basename(file, ".cmake.exs")}_#{line}"

  defmacro cmake(
             [boilerplate: _boilerplate] = opts \\ [
               boilerplate: true
             ],
             block
           ) do
    # var!(bound_comments)

    # block = Macro.escape(block)

    block =
      Macro.escape(
        elem(List.first(block), 1)
        |> Macro.update_meta(&Keyword.put(&1, :line, __CALLER__.line))
      )

    quote do
      # dbg(__ENV__)
      # unquote(dbg(binding()))
      cmake_gen(unquote(opts), unquote(block), var!(bound_comments))
      |> Code.eval_quoted(binding(), __ENV__)
    end

    # |> Code.eval_quoted(binding(:record_testing), __CALLER__)

    # |> dbg

    # binding(__CALLER__) |> dbg
    # Macro.Env.vars(__CALLER__) |> dbg

    # block_id = get_block_id(__CALLER__.file, __CALLER__.line)
    # comments = get_comments(block_id)

    # cmake_gen(opts, block, comments)
  end

  def cmake_gen([boilerplate: true], block, comments) do
    Generic.cmake_minimum_required()
    Generic.stamp_default_env()

    {:__block__, block_meta, block_elements} = block
    block_starting_line = block_meta[:line]
    block_ending_line = elem(List.last(block_elements), 1)[:line]

    block_elements =
      (block_elements ++ comments_to_ast(comments, block_starting_line, block_ending_line))
      |> sort_ast_by_line()
      |> replace_elixir_with_cmake_calls()

    block_elements = block_elements ++ [quote(do: ErlNif.add_erts_to_target("${PROJECT_ID}"))]
    {:__block__, block_meta, block_elements}
  end

  def cmake_gen([boilerplate: false], block, comments) do
    {:__block__, block_meta, block_elements} = block
    block_starting_line = block_meta[:line]
    block_ending_line = elem(List.last(block_elements), 1)[:line]

    block_elements =
      (block_elements ++ comments_to_ast(comments, block_starting_line, block_ending_line))
      |> sort_ast_by_line()
      |> replace_elixir_with_cmake_calls()

    {:__block__, block_meta, block_elements}
  end

  def replace_elixir_with_cmake_calls(block_elements) do
    Macro.postwalk(block_elements, fn el ->
      replace_element(el)
    end)
  end

  def replace_element(
        {:=, _assignment_meta,
         [
           {function_name, _function_meta, nil},
           {:fn, _fn_meta,
            [
              {:->, _arg_meta,
               [
                 function_args,
                 body
               ]}
            ]}
         ]} = _el
      ) do
    body =
      case body do
        {:__block__, _block_meta, body} -> body
        body -> body
      end

    function_args_as_atoms = Enum.map(function_args, fn {key, _, _} -> key end)
    function_args_as_strings = Enum.map(function_args, fn {key, _, _} -> "#{key}" end)
    function_args_as_key_calls = Enum.map(function_args, fn {key, _, _} -> "${#{key}}" end)
    # variable_assignment =
    #   Enum.map(Macro.escape(function_args), fn {:{}, [], [key, meta, nil]} ->
    #     Macro.var(key, __MODULE__)
    #   end)

    # dbg(variable_assignment)
    vars = Enum.map(function_args_as_atoms, &Macro.var(&1, nil))

    combined_chunks =
      [
        quote do
          append_line()

          Cmakex.Templates.Function.function_header(
            unquote(function_name),
            unquote(function_args_as_strings)
          )

          Cmakex.ETS.RuntimeConfig.increment_depth()
        end,
        quote do
          var_count = length(unquote(function_args_as_key_calls))

          [unquote_splicing(vars)] = [unquote_splicing(function_args_as_key_calls)]

          dbg(unquote(vars))
          # dbg(x)
          # Enum.each(unquote(function_args_as_strings), fn arg ->
          # end)

          # unquote_splicing(variable_assignment)
          unquote(body)
        end,
        quote do
          Cmakex.ETS.RuntimeConfig.decrement_depth()
          Cmakex.Templates.Function.function_close(unquote(function_name))
          append_line()
        end
      ]

    # final_body =
    #   first_piece ++
    #      ++ second_piece

    dbg(combined_chunks)

    # {:=, assignment_meta,
    #  [
    #    {function_name, function_meta, nil},
    #    {:fn, fn_meta,
    #     [
    #       {:->, arg_meta,
    #        [
    #          function_args,
    #          {:__block__, block_meta, final_body}
    #        ]}
    #     ]}
    #  ]}
    combined_chunks

    # quote bind_quoted: [
    #         function_name: function_name,
    #         function_args: function_args
    #       ] do
    #   Cmakex.Templates.Function.function_header(
    #     function_name,
    #     function_args
    #   )

    #   # Code.eval_quoted(body, function_args)
    #   Cmakex.Templates.Function.function_close(function_name)
    # end

    # el
  end

  def replace_function_body({:__block__, meta, body}), do: body
  def replace_function_body(body), do: body

  def replace_element(
        {{:., _meta, [{function_name, _function_meta, nil}]}, _call_meta, call_args} = el
      ) do
    quote bind_quoted: [function_name: function_name, call_args: call_args] do
      Cmakex.Templates.Function.function_call(
        function_name,
        call_args
      )
    end
  end

  def replace_element(el) do
    el
  end

  def comments_to_ast(comments, block_starting_line, block_ending_line) do
    Enum.filter(comments, fn %{line: line} ->
      line > block_starting_line && line < block_ending_line
    end)
    |> Enum.map(fn %{line: line, text: text} ->
      quote line: line, do: append_line(unquote(text))
    end)
  end

  def append_comments_ast_to_elements_list(comments_ast, block_elements) do
    block_elements ++ comments_ast
  end

  def sort_ast_by_line(elements) do
    elements
    |> Enum.sort_by(fn {_, meta, _} ->
      meta[:line]
    end)
  end

  # def get_elements_in_block(block) do
  #   List.first(block)
  #   |> elem(1)
  #   |> case do
  #     {:__block__, [line: 1], elements} -> elements
  #     element -> [element]
  #   end
  # end

  def insert_comments(comments) when is_list(comments) do
    dbg(comments)
    # quote location: :keep do
    # Enum.each(comments, fn comment ->
    #   # dbg(comment)
    #   append_line(comment.text, comment.line)
    # end)

    # Enum.map(unquote(comments), &to_comment/1)
    # |> Enum.concat(Macro.escape(unquote(expanded_block)))
    # |> Enum.sort_by(fn element ->
    #   Keyword.get(elem(element, 1), :line)
    # end)
    # end
  end

  def replace_elixir_ast_with_valid_cmake(block) do
    # Macro.to_string(block)
    # |> String.split("\n")
    # |> Enum.map(fn el ->
    #   el = String.trim(el)
    #   n = Macro.escape(Macro.unescape_string(el), unquote: false)
    #   dbg(n)
    #   n
    # end)

    # {post_walked, accumulated} =
    quote do
      {post_walked, accumulated} =
        Macro.postwalk(unquote(Macro.escape(block) |> Enum.reverse()), [], fn el, acc ->
          parse_element(el, acc)
        end)

      # {new_ast, acc} =
      #   Macro.traverse(
      #     unquote(Macro.escape(block)),
      #     [],
      #     fn el, acc -> {el, acc} end,
      #     fn el, acc -> {el, acc} end
      #   )

      # |> dbg

      accumulated = accumulated |> Enum.reverse()
      dbg(accumulated)
      # {_, bind} = Code.eval_quoted(new_ast, binding(), unquote(Macro.escape(__CALLER__)))
      # Code.eval_quoted(accumulated, binding(), unquote(Macro.escape(__CALLER__)))
    end

    # post_walked
    # quote do
    #   unquote_splicing(post_walked)
    #   unquote_splicing(accumulated)
    # end

    # dbg(post_walked)
    # dbg(Enum.reverse(accumulated))

    # quote location: :keep do
    # post_walked
    # unquote()
    # unquote(accumulated)

    # {ast_result, _total_lines} = Macro.postwalk(Macro.escape(unquote(quoted)), &parse_call(&1))

    # ast_result |> Enum.filter(fn el -> el != nil end)
    # end
  end

  # defmacro parse_call(el) do
  #   el
  # end

  # def handle_element(el, acc) do
  #   case el do
  #     val ->
  #       # dbg(val)
  #       parse_element(val, acc)
  #   end
  # end

  # Function assignment
  def parse_element(
        {:=, _, [variable, {:fn, _, [{:->, _, [arguments, expression]}]}]} = el,
        acc
      ) do
    todo =
      quote do
        Cmakex.Templates.Function.function_header(
          unquote(Macro.escape(variable)),
          unquote(Macro.escape(arguments))
        )

        increment_depth()

        # unquote(parse_element(expression, [el | acc]))

        # decrement_depth()

        # Cmakex.Templates.Function.function_close(unquote(variable))
      end

    {el, [[todo | el] | acc]}
  end

  def parse_element({{:., meta, [{variable, [line: line], nil}]}, _meta, args} = el, acc) do
    dbg(variable)

    todo =
      quote line: line do
        Cmakex.Templates.Function.function_call(
          to_string(unquote(variable)),
          unquote(args)
        )
      end

    {el, [[todo | el] | acc]}
  end

  def parse_element(el, acc), do: {el, [[el] | acc]}

  # dbg("Assignment of value")

  # case el do
  #   # {:__block__, [handled: true, line: line] = meta, _el} ->
  #   #   dbg("Shit should fall through.")
  #   #   {nil, line_number}

  #   {:fn, _, [{:->, _, [arguments, expression]}]} ->
  #     dbg("Value is a function.")

  #     # escaped_el = Macro.escape(el)
  #     # escaped_key = Macro.escape(key)
  #     # escaped_arguments = Macro.escape(arguments)
  #     # escaped_expression = Macro.escape(expression)

  #     # dbg({escaped_el, escaped_key, escaped_arguments, escaped_expression})

  #     # fixed_args =
  #     #   Enum.map(arguments, fn {arg_key, _, _} ->
  #     #     arg_key
  #     #   end)

  #     # definition =
  #     #   quote do
  #     #     Cmakex.Templates.Function.function_header(unquote(key), unquote(fixed_args))

  #     #     increment_depth()

  #     #     unquote(expression)

  #     #     decrement_depth()

  #     #     Cmakex.Templates.Function.function_close(unquote(key))

  #     #   end

  #     # definition
  #     el

  #   _ ->
  #     dbg(el)
  #     el
  # end

  # defp parse_call({:dbg, meta, [value]} = el, line_number) do
  #   result =
  #     quote([line: line_number], do: message(:DEBUG, unquote(value)))

  #   # result =
  #   #   quote line: line_number, bind_quoted: [value: value] do
  #   #     Cmakex.Templates.Message.message(:DEBUG, value)
  #   #   end

  #   {result, line_number + 1}
  # end

  defmacro parse_call({{:., _, [{function_name, _, nil}]}, meta, args} = el) do
    # function_call(to_string(function_name), function_args)

    quote do
      Cmakex.Templates.Function.function_call(to_string(unquote(function_name)), unquote(args))
    end
  end

  defmacro parse_call(el, line_number) do
    case el do
      # {:__aliases__, meta, [key]} = alias_call ->
      # dbg("Returning #{"${#{key}}"}")
      # dbg(alias_call)
      # {"#{key}", line_number + 1}

      el ->
        {el, line_number + 1}
    end
  end

  # defp with_updated_meta(quoted, line, newlines \\ 1) do
  #   quoted
  #   |> Macro.update_meta(&Keyword.put(&1, :closing, line: line))
  #   |> Macro.update_meta(&Keyword.put(&1, :end_of_expression, newlines: newlines, line: line))
  # end

  # defmacro to_comment(comment) do
  #   append_line(quote do: unquote(comment))

  #   quote do
  #     dbg(unquote(comment))
  #   end
  # end

  # def insert_newlines(expanded_block) do
  #   Enum.reduce_while(expanded_block, [], fn element, acc ->
  #     current_index =
  #       Enum.find_index(expanded_block, fn el ->
  #         element == el
  #       end)

  #     # dbg(element)

  #     add_newline_if_line_difference_exceeded(expanded_block, element, current_index, acc)
  #   end)
  #   |> Enum.concat(expanded_block)
  #   |> Enum.sort_by(fn element ->
  #     Keyword.get(elem(element, 1), :line)
  #   end)
  # end

  # defp add_newline_if_line_difference_exceeded(expanded_block, element, current_index, acc) do
  #   case Enum.at(expanded_block, current_index + 1, nil) do
  #     nil ->
  #       {:halt, acc}

  #     {{:., _, [_]}, _, _} ->
  #       # dbg("Should fall")
  #       {:cont, acc}

  #     next ->
  #       to_classify = elem(next, 0)

  #       # and Macro.classify_atom(to_classify) != :unquoted do
  #       if line_difference(next, element) > 1 do
  #         line = elem(element, 1)[:line] + 1

  #         newline_ast =
  #           quote line: line, unquote: false do
  #             append_line()
  #           end
  #           |> with_updated_meta(line, 1)

  #         {:cont, [newline_ast | acc]}
  #       else
  #         {:cont, acc}
  #       end
  #   end
  # end

  # defp line_difference(left, right) do
  #   # dbg({left, right})

  #   Keyword.get(elem(left, 1), :line) -
  #     Keyword.get(elem(right, 1), :closing, line: Keyword.get(elem(right, 1), :line))[:line]
  # end
end
