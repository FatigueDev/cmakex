defmodule Cmakex do
  @moduledoc false

  import Cmakex.Utils
  import Cmakex.Templates

  defmacro __using__(project_name: project_name, cmake_minimum_required: version) do
    quote do
      import Cmakex.Templates
      import Cmakex.Sigils
      import Cmakex.Utils

      var!(project_name) = unquote(project_name)

      ~m"cmake_minimum_required(VERSION #{unquote(version)})"n
      project(unquote(project_name))
      newline()
      set_default_env()
    end
  end
end
