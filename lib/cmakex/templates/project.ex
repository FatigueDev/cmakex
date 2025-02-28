defmodule Cmakex.Templates.Project do
  @moduledoc false

  import Cmakex.ETS.Line

  def project(project_name, opts \\ []) do
    # quote bind_quoted: [project_name: project_name, opts: opts] do
    append_inline_with_args("project", to_string(project_name), opts)
    # end

    # List.first(block)
    # |> elem(1)
    # |> elem(2)
    # |> dbg

    # # IEx.Helpers.i(
    # quote([:line]) do
    #   # unquote(Macro.dbg(block, :metadata, %Macro.Env{}))
    #   unquote(block)
    # end

    # )
  end

  # def project(project_name) do
  #   append_line("project(#{to_string(project_name)})")
  #   append_line()
  # end

  # def project(project_name, opts) do
  #   append_inline_with_args("project", to_string(project_name), opts)
  # end

  #   end
  # end
end
