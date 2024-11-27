defmodule Cmakex do
  @moduledoc false

  import Cmakex.Utils
  import Cmakex.Templates

  defmacro __using__(cmake_minimum_required: version) do
    quote do
      import Cmakex.Templates
      import Cmakex.Sigils
      import Cmakex.Utils

      ~m"cmake_minimum_required(VERSION #{unquote(version)})"n
      newline()
      set_default_env()
    end
  end
end
