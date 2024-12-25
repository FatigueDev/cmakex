defmodule Cmakex.Helpers do
  @moduledoc false

  defmodule Path do
    @moduledoc false

    alias Elixir.Path

    def caller_cwd, do: Path.dirname(Mix.Project.project_file())

    def mix_project_root, do: File.cwd!()

    def natives_root, do: Path.join(mix_project_root(), "natives")

    def project_natives_path(project_name) do
      Path.join(natives_root(), project_name)
    end

    def project_build_path(project_name),
      do: Path.join(project_natives_path(project_name), "_build")

    def project_build_path(project_name, build_type) when build_type == :debug do
      Path.join(project_build_path(project_name), "debug")
    end

    def project_build_path(project_name, build_type) when build_type == :release do
      Path.join(project_build_path(project_name), "release")
    end

    def cmakex_file_path(project_name),
      do: Path.join(project_natives_path(project_name), "CMakeLists.txt")

    def build_output_path(project_name) do
      Path.join([
        mix_project_root(),
        "priv",
        "cmakex_natives",
        to_string(Mix.env()),
        project_name
      ])
    end

    def shared_object_file(project_name) do
      {os_family, _os_name} = :os.type()

      output_path = build_output_path(project_name)
      file_name = os_specific_filename(os_family, project_name)

      Path.join([output_path, file_name])
      |> to_charlist()
    end

    def os_specific_filename(os_family, project_name) do
      if os_family == :unix do
        "lib" <> project_name
      else
        project_name
      end
    end
  end

  defmodule Environment do
    @moduledoc false

    def get_system_or_default(key, default), do: System.get_env(key, default)
  end
end
