defmodule Cmakex.Templates.Generic do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.Templates.Set
  alias Cmakex.Helpers.Environment

  # defmacro __using__(_) do
  #   quote do
  def comment(text) do
    append_line("# #{text}")
  end

  def include(value) do
    append_line("include(#{value})")
  end

  def nl do
    append_line(nil)
  end

  def nl(amount) when amount > 0 do
    Enum.each(0..amount, fn _ -> nl() end)
  end

  def cmake_minimum_required(version) do
    append_line("cmake_minimum_required(VERSION #{version})")
  end

  def stamp_default_env do
    config = Mix.Project.config()
    root_dir = :code.root_dir()
    erl_interface_dir = Path.join(root_dir, "usr")
    erts_dir = Path.join(root_dir, "erts-#{:erlang.system_info(:version)}")
    erts_include_dir = Path.join(erts_dir, "include")
    erl_ei_lib_dir = Path.join(erl_interface_dir, "lib")
    erl_ei_include_dir = Path.join(erl_interface_dir, "include")

    comment("REGION:Elixir & Erlang Environment")
    comment("Add Mix environment configurations")
    set("MIX_TARGET", Environment.get_system_or_default("MIX_TARGET", "host"))
    set("MIX_ENV", to_string(Mix.env()))
    set("MIX_BUILD_PATH", Mix.Project.build_path(config))
    set("MIX_APP_PATH", Mix.Project.app_path(config))
    set("MIX_COMPILE_PATH", Mix.Project.compile_path(config))
    set("MIX_CONSOLIDATION_PATH", Mix.Project.consolidation_path(config))
    set("MIX_DEPS_PATH", Mix.Project.deps_path(config))
    set("MIX_MANIFEST_PATH", Mix.Project.manifest_path(config))
    nl()

    comment("Rebar naming")
    set("ERL_EI_LIBDIR", Environment.get_system_or_default("ERL_EI_LIBDIR", erl_ei_lib_dir))

    set(
      "ERL_EI_INCLUDE_DIR",
      Environment.get_system_or_default("ERL_EI_INCLUDE_DIR", erl_ei_include_dir)
    )

    nl()

    comment("erlang.mk naming")

    set(
      "ERTS_INCLUDE_DIR",
      Environment.get_system_or_default("ERTS_INCLUDE_DIR", erts_include_dir)
    )

    set(
      "ERL_INTERFACE_LIB_DIR",
      Environment.get_system_or_default("ERL_INTERFACE_LIB_DIR", erl_ei_lib_dir)
    )

    set(
      "ERL_INTERFACE_INCLUDE_DIR",
      Environment.get_system_or_default("ERL_INTERFACE_INCLUDE_DIR", erl_ei_include_dir)
    )

    nl()

    comment("Disable default erlang values")
    unset("BINDIR")
    unset("ROOTDIR")
    unset("PROGNAME")
    unset("EMU")
    comment("END_REGION:Elixir & Erlang Environment")
    nl()
  end

  # end
  # end
end
