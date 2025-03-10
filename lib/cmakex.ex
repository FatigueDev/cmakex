defmodule Cmakex do
  @moduledoc false

  defmacro __using__(_) do
    quote generated: true do
      import Cmakex
      import Cmakex.Records.Line
      import Cmakex.Cmake
      import Cmakex.Helpers

      use Cmakex.Templates
    end
  end
end
