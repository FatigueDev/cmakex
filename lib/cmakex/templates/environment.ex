defmodule Cmakex.Templates.Environment do
  @moduledoc false

  # import Cmakex.ETS.Line

  # defmacro __using__(_) do
  #   quote do
  def project_source_dir, do: "${PROJECT_SOURCE_DIR}"
  def cmake_binary_dir, do: "${CMAKE_BINARY_DIR}"

  def mix_target, do: "${MIX_TARGET}"
  def mix_env, do: "${MIX_ENV}"
  def mix_build_path, do: "${MIX_BUILD_PATH}"
  def mix_app_path, do: "${MIX_APP_PATH}"
  def mix_compile_path, do: "${MIX_COMPILE_PATH}"
  def mix_consolidation_path, do: "${MIX_CONSOLIDATION_PATH}"
  def mix_deps_path, do: "${MIX_DEPS_PATH}"
  def mix_manifest_path, do: "${MIX_MANIFEST_PATH}"

  def erl_ei_libdir, do: "${ERL_EI_LIBDIR}"
  def erl_ei_include_dir, do: "${ERL_EI_INCLUDE_DIR}"

  def erts_include_dir, do: "${ERTS_INCLUDE_DIR}"

  def erl_interface_lib_dir, do: "${ERL_INTERFACE_LIB_DIR}"
  def erl_interface_include_dir, do: "${ERL_INTERFACE_INCLUDE_DIR}"
  #   end
  # end
end
