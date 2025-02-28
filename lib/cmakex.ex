defmodule Cmakex do
  @moduledoc false

  # import Cmakex.ETS.Line
  # import Cmakex.ETS.RuntimeConfig

  # defmacro cmake_initialization(minimum_version \\ "3.10") do
  #   quote location: :keep do
  #   end
  # end

  defmacro __using__(_) do
    quote do
      import Cmakex
      import Cmakex.Records.Line
      import Cmakex.Cmake

      use Cmakex.Templates
    end
  end
end
