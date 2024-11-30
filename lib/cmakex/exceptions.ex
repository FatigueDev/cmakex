defmodule Cmakex.Exceptions.NoMixDependencyFound do
  defexception [:message, :missing_dependencies]

  # defp message_builder(missing_deps) when is_list(missing_deps) do
  #   """
  #   \nCmakex sees that you are missing the following dependencies from your MixProject:\n
  #   #{Enum.map_join(missing_deps, "\n", fn {dep, notes} -> ":#{dep} ~ Cmakex author notes:\n#{notes}\n" end)}
  #   Please append this missing dependency to your MixProject deps so CMake can run correctly.

  #   If any of these missing dependencies are not Elixir dependencies, that's alright;
  #   we can add non-elixir sources to our dependency tree.

  #   Example:

  #       def deps() do
  #         [
  #           # Add something like this:
  #           {:my_dependency,
  #            git: "https://github.com/some_user/my_dependency.git",
  #            tag: "1.3",
  #            runtime: false,
  #            compile: false,
  #            app: false
  #           }
  #         ]
  #       end
  #   """
  # end

  # defp message_builder({missing_dep, required_version_notes}) do
  #   """
  #   \nCmakex sees that you are missing the :#{missing_dep} dependency from your MixProject deps list.
  #   Please append this missing dependency to your MixProject deps so CMake can run correctly.

  #   This cmake.exs author has left the following version notes:
  #   #{required_version_notes}

  #   If :#{missing_dep} is not an Elixir dependency, that's alright;
  #   we can add non-elixir source to our dependency tree.

  #   Example:

  #       def deps() do
  #         [
  #           # Add something like this:
  #           {:#{missing_dep},
  #            git: "https://github.com/some_user/#{missing_dep}.git",
  #            tag: "1.3",
  #            runtime: false,
  #            compile: false,
  #            app: false
  #           }
  #         ]
  #       end
  #   """
  # end

  # @impl true
  # def exception(missing_depencencies) when is_list(missing_depencencies) do
  #   %Cmakex.Exceptions.NoMixDependencyFound{
  #     message: message_builder(missing_depencencies),
  #     missing_dependencies: missing_depencencies
  #   }
  # end

  # @impl true
  # def exception(missing_dependency) do
  #   %Cmakex.Exceptions.NoMixDependencyFound{
  #     message: message_builder(missing_dependency),
  #     missing_dependencies: [missing_dependency]
  #   }
  # end
end
