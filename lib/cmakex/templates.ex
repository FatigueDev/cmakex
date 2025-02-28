defmodule Cmakex.Templates do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import Cmakex.Templates.Add
      import Cmakex.Templates.Conditions
      # import Cmakex.Templates.Cmake
      import Cmakex.Templates.Environment
      import Cmakex.Templates.ErlNif
      import Cmakex.Templates.FetchContent
      import Cmakex.Templates.Function
      import Cmakex.Templates.Generic
      import Cmakex.Templates.Message
      import Cmakex.Templates.Project
      import Cmakex.Templates.Target
      import Cmakex.Templates.Set
    end
  end
end
