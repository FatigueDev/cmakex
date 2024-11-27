defmodule Cmakex.Utils do
  @moduledoc false

  import Cmakex.Process
  import Cmakex.Templates

  def create_cmake_file(path) do
    if !File.dir?(path) do
      File.mkdir_p(path)
    end

    File.write(Path.join(path, "CMakeLists.txt"), get_proc_joined())
  end

  def set_default_env() do
    config = Mix.Project.config()
    root_dir = :code.root_dir()
    erl_interface_dir = Path.join(root_dir, "usr")
    erts_dir = Path.join(root_dir, "erts-#{:erlang.system_info(:version)}")
    erts_include_dir = Path.join(erts_dir, "include")
    erl_ei_lib_dir = Path.join(erl_interface_dir, "lib")
    erl_ei_include_dir = Path.join(erl_interface_dir, "include")

    comment("REGION:Elixir & Erlang Environment")
    comment("Add Mix environment configurations")
    set("MIX_TARGET", env("MIX_TARGET", "host"))
    set("MIX_ENV", to_string(Mix.env()))
    set("MIX_BUILD_PATH", Mix.Project.build_path(config))
    set("MIX_APP_PATH", Mix.Project.app_path(config))
    set("MIX_COMPILE_PATH", Mix.Project.compile_path(config))
    set("MIX_CONSOLIDATION_PATH", Mix.Project.consolidation_path(config))
    set("MIX_DEPS_PATH", Mix.Project.deps_path(config))
    set("MIX_MANIFEST_PATH", Mix.Project.manifest_path(config))
    newline()

    comment("Rebar naming")
    set("ERL_EI_LIBDIR", env("ERL_EI_LIBDIR", erl_ei_lib_dir))
    set("ERL_EI_INCLUDE_DIR", env("ERL_EI_INCLUDE_DIR", erl_ei_include_dir))
    newline()

    comment("erlang.mk naming")
    set("ERTS_INCLUDE_DIR", env("ERTS_INCLUDE_DIR", erts_include_dir))
    set("ERL_INTERFACE_LIB_DIR", env("ERL_INTERFACE_LIB_DIR", erl_ei_lib_dir))
    set("ERL_INTERFACE_INCLUDE_DIR", env("ERL_INTERFACE_INCLUDE_DIR", erl_ei_include_dir))
    newline()

    comment("Disable default erlang values")
    unset("BINDIR")
    unset("ROOTDIR")
    unset("PROGNAME")
    unset("EMU")
    comment("END_REGION:Elixir & Erlang Environment")
    newline()
  end

  defp env(var, default) do
    System.get_env(var) || default
  end

  def add_mix_dependency(app, required_version_notes) do
    Process.put(:cmakex_dependencies, get_mix_dependencies() ++ [{app, required_version_notes}])
  end

  defp get_mix_dependencies() do
    Process.get(:cmakex_dependencies, [])
  end

  def ensure_mix_dependencies() do
    cmakex_dependencies = get_mix_dependencies()
    mix_project_dependencies = Mix.Project.deps_apps()

    missing_dependencies =
      Enum.filter(cmakex_dependencies, fn {dep, _} ->
        dep not in mix_project_dependencies
      end)

    case missing_dependencies do
      [{missing_dep, required_version_notes}] ->
        raise(Cmakex.Exceptions.NoMixDependencyFound, {missing_dep, required_version_notes})

      missing_deps when is_list(missing_deps) and length(missing_deps) > 0 ->
        raise(Cmakex.Exceptions.NoMixDependencyFound, missing_deps)

      _ ->
        :ok
    end
  end
end
