defmodule Example.Nif do
  @on_load :on_load

  def on_load() do
    :erlang.load_nif(Path.expand("build/libcmake_example"), nil)
  end

  def check, do: nil
end
