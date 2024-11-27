defmodule Cmakex.Guards do
  @moduledoc false
  defguard is_non_negative_integer(value) when is_integer(value) and value > 0
end
