defmodule Mix.Tasks.Cmakex.Natives do
  @moduledoc false

  use Mix.Task

  alias Cmakex.ETS.Line
  alias Cmakex.ETS.RuntimeConfig

  @aliases [v: :verbose, d: :debug_output, f: :fresh, e: :except]
  @switches [verbose: :boolean, debug_output: :boolean, fresh: :boolean, except: :string]

  def run(command_line_args) do
    options = OptionParser.parse(command_line_args, aliases: @aliases, switches: @switches)

    if Keyword.has_key?(elem(options, 0), :verbose) do
      Process.put(:cmakex_build_verbose, "--verbose")
    end

    if Keyword.has_key?(elem(options, 0), :debug_output) do
      Process.put(:cmakex_build_debug_output, "--debug-output")
    end

    if Keyword.has_key?(elem(options, 0), :fresh) do
      Process.put(:cmakex_build_fresh, "--fresh")
    end

    exclusions =
      Keyword.get(elem(options, 0), :except, "")
      |> OptionParser.split()
      |> Enum.map(fn key -> String.to_atom(key) end)

    current_project = {Mix.Project.config()[:app], File.cwd!()}

    deps_list =
      [
        current_project
        | Enum.map(
            Mix.Project.deps_paths(),
            fn {dep, path} ->
              {dep, Path.absname(path, File.cwd!())}
            end
          )
      ]
      |> Enum.reject(fn {dep, _path} ->
        dep in exclusions
      end)

    compile_dependencies(deps_list)
  end

  defp compile_dependencies(deps_list) do
    RuntimeConfig.create_table()
    Line.create_table()

    Enum.each(deps_list, fn dep ->
      compile_files(dep)
    end)
  end

  defp compile_files({_dep_app, dep_path} = dep) do
    case Path.wildcard(Path.join(dep_path, "compile/**/*.cmake.exs")) do
      [] ->
        nil

      compile_files when is_list(compile_files) ->
        eval_in_dependency(dep, compile_files)
    end
  end

  defp eval_in_dependency({_dep_app, dep_path}, compile_files) do
    File.cd!(dep_path, fn ->
      Enum.each(compile_files, fn file ->
        project_name = Path.basename(file, ".cmake.exs")
        RuntimeConfig.clear_table()
        Line.clear_table()

        {{_, _, quoted}, bound_comments} =
          File.read!(file)
          |> Code.string_to_quoted_with_comments!(token_metadata: true)

        quoted_filtered_to_cmake_blocks(quoted)
        |> quoted_filtered_to_cmake_blocks()
        |> assign_comments_for_filtered_cmake_blocks(bound_comments, project_name)

        Code.eval_quoted(quoted, [], file: file)

        Cmakex.Build.create_cmake_file(project_name)
        Cmakex.Build.build(project_name)
      end)
    end)
  end

  defp assign_comments_for_filtered_cmake_blocks(quoted, bound_comments, project_name) do
    Enum.each(quoted, fn {_, _, _} = block ->
      comments_for_block =
        with s <- elem(block, 1)[:do][:line], e <- elem(block, 1)[:end][:line] do
          s..e
          |> Range.to_list()
          |> get_comments_for_cmake_block(bound_comments)
        end

      RuntimeConfig.set_comments(
        "block_#{project_name}_#{elem(block, 1)[:do][:line]}",
        comments_for_block
      )
    end)
  end

  defp get_comments_for_cmake_block(block_range, comments) do
    Enum.filter(comments, fn %{line: line} ->
      line in block_range
    end)
  end

  defp quoted_filtered_to_cmake_blocks(quoted) do
    Enum.filter(quoted, &(elem(&1, 0) == :cmake))
  end
end
