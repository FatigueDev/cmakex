defmodule Cmakex.Templates.Conditions do
  @moduledoc false

  defmacro __using__ do
    quote do
      @moduledoc false

      import Sigils

      defmacro _if(condition) do
        quote do
          ~m"if(#{unquote(condition)})"nu
        end
      end

      defmacro _else do
        quote do
          ~m""d
          ~m"else()"nu
        end
      end

      defmacro _elseif(condition) do
        quote do
          ~m""d
          ~m"elseif(#{unquote(condition)})"nu
        end
      end

      defmacro _endif do
        quote do
          ~m"endif(#{unquote()})"nd
        end
      end
    end
  end
end
