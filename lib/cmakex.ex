defmodule Cmakex do
  @moduledoc false

  # import Cmakex.ETS.Line
  # import Cmakex.ETS.RuntimeConfig

  # defmacro cmake_initialization(minimum_version \\ "3.10") do
  #   quote location: :keep do
  #   end
  # end

  defmacro __using__(_) do
    quote generated: true do
      import Cmakex
      import Cmakex.Records.Line
      import Cmakex.Cmake
      import Cmakex.Helpers

      use Cmakex.Templates

      # dbg(bound_comments)

      # test = var!(bound_comments)
      # unquote(dbg(test))

      # var!(bound_comments) = binding()
      # var!(module_name)
    end
  end
end
