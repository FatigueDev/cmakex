# defmodule Cmakex.Templates.Include do
#   @moduledoc false

#   import Cmakex.ETS.Line

#   defmacro __using__(_) do
#     quote do
#       def include(value) do
#         append_line("include(#{value})")
#       end
#     end
#   end
# end
