defmodule Cmakex.Templates.Message do
  @moduledoc false
  import Cmakex.Sigils

  defmacro __using__(_) do
    quote do
      def message(message), do: message(:notice, message)
      def message(:notice, message), do: ~m/message(NOTICE "#{message}")/n
      def message(:status, message), do: ~m/message(STATUS "#{message}")/n
      def message(:warning, message), do: ~m/message(WARNING "#{message}")/n
      def message(:error, message), do: ~m/message(ERROR "#{message}")/n
    end
  end
end
