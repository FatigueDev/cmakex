defmodule Example.Nif do
  @moduledoc false

  @nifs [check: 0]
  @on_load :onload

  def onload do
    Code.ensure_loaded(Cmakex.Helpers.Path)
    :erlang.load_nif(Cmakex.Helpers.Path.shared_object_file("record_testing"), 0)
  end

  def check, do: :erlang.nif_error("Not loaded.")
end
