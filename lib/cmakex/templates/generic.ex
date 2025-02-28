defmodule Cmakex.Templates.Generic do
  @moduledoc false

  import Cmakex.ETS.Line
  import Cmakex.Templates.Set
  alias Cmakex.Helpers.Environment

  defmacro comment(text) do
    quote do
      append_line("# #{unquote(text)}")
    end
  end

  defmacro include(value) do
    append_line("include(#{value})")
  end

  def cmake_minimum_required(version \\ "3.10") do
    append_line("cmake_minimum_required(VERSION #{version})")
    append_line()
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
    append_line()

    comment("Rebar naming")
    set("ERL_EI_LIBDIR", Environment.get_system_or_default("ERL_EI_LIBDIR", erl_ei_lib_dir))

    set(
      "ERL_EI_INCLUDE_DIR",
      Environment.get_system_or_default("ERL_EI_INCLUDE_DIR", erl_ei_include_dir)
    )

    append_line()

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

    append_line()

    comment("Disable default erlang values")
    unset("BINDIR")
    unset("ROOTDIR")
    unset("PROGNAME")
    unset("EMU")
    comment("END_REGION:Elixir & Erlang Environment")
    append_line()
  end
end
