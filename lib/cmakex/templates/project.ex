defmodule Cmakex.Templates.Project do
  @moduledoc false

  import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def project(project_name) do
    append_line("project(#{project_name})")
  end

  def project(project_name, opts) do
    append_inline_with_args("project", project_name, opts)
  end

  #   end
  # end
end
