defmodule Example.Nif do
  @on_load :on_load

  def on_load() do
    :erlang.load_nif(Path.expand("priv/cmake_example/libcmake_example"), nil)
  end

  def check, do: nil
end
