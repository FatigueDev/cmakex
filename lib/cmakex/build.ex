defmodule Cmakex.Build do
  @moduledoc false

  require Cmakex.Records.Line
  import Cmakex.ETS.Line

  @after_compile __MODULE__

  defmacro __after_compile__(_, _) do
    case System.find_executable("cmake") do
      nil ->
        raise(%ArgumentError{
          message: ~S"""

          You are missing CMake from your PATH environment variable.
          Please visit https://cmake.org/download/ and run the installer to use Cmakex.
          """
        })

      _ ->
        :ok
    end
  end

  def create_cmake_file(project_name) do
    project_path = Cmakex.Helpers.Path.project_natives_path(project_name)

    if !File.dir?(project_path) do
      File.mkdir_p(project_path)
    end

    File.write(
      Cmakex.Helpers.Path.cmakex_file_path(project_name),
      line_records_to_string()
    )
  end

  def build(project_name) do
    case Mix.env() do
      :dev ->
        do_build(:Debug, project_name)

      :prod ->
        do_build(:Release, project_name)

      _ ->
        IO.puts("Should run either :dev or :prod to compile #{project_name}")
    end
  end

  def do_build(build_type, project_name) do
    build_type_flag = "-DCMAKE_BUILD_TYPE=#{build_type}"

    build_output_path_flag =
      "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=#{Cmakex.Helpers.Path.build_output_path(project_name)}"

    build_verbose = Process.get(:cmakex_build_verbose, "")
    build_debug_output = Process.get(:cmakex_build_debug_output, "")
    build_fresh = Process.get(:cmakex_build_fresh, "")

    Mix.Shell.cmd(
      "cmake -S . -B ./_build/#{build_type} #{build_type_flag} #{build_output_path_flag} #{build_fresh} #{build_debug_output} && cd ./_build/#{build_type} && cmake --build ./ #{build_verbose}",
      [cd: Cmakex.Helpers.Path.project_natives_path(project_name)],
      fn io -> IO.write(io) end
    )
  end
end
