defmodule Cmakex do
  @moduledoc false

  import Cmakex.Templates.Generic

  defmacro __using__(opts) do
    minimum_version = Keyword.get(opts, :cmake_minimum_required, "3.10")

    quote do
      cmake_minimum_required(unquote(minimum_version))
      nl()
      stamp_default_env()
    end
  end
end
