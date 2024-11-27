defmodule Cmakex.Templates.Message do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def message(message), do: message(:notice, message)
      def message(:notice, message), do: ~m/message(NOTICE "#{message}")/
      def message(:status, message), do: ~m/message(STATUS "#{message}")/
      def message(:warning, message), do: ~m/message(WARNING "#{message}")/
      def message(:error, message), do: ~m/message(ERROR "#{message}")/
    end
  end
end
