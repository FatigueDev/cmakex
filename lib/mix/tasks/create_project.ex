defmodule Mix.Tasks.Cmakex.New do
  @moduledoc false

  use Mix.Task

  def run(command_line_args) do
    # OptionParser.parse(command_line_args, aliases: @aliases, strict: @strict)
    case command_line_args do
      [project_name] when is_binary(project_name) ->
        project_name

      _ ->
        IO.warn(
          "\nName given to cmakex.new was not a string name we could parse.\nYou should use the command like this:\n\n\tmix cmakex.new my_project_name\n"
        )

        nil
    end
    |> create_project()
  end

  def create_project(nil), do: nil

  def create_project(project_name) do
    current_project_compile_path = Path.join(Cmakex.Helpers.Path.caller_cwd(), "compile")
    compile_file = Path.join(current_project_compile_path, "#{project_name}.cmake.exs")

    if not File.dir?("compile") do
      File.mkdir_p(current_project_compile_path)
    end

    File.write(compile_file, cmake_exs_template(project_name))
  end

  defp cmake_exs_template(project_name) do
    """
    use Cmakex
    use Cmakex.Templates

    # Define a new project in the CMakeLists with the given name
    project_name = to_string(:#{to_string(project_name)})
    project(project_name)
    nl()

    ### START examples
    ## Some example functionality :)

    message("We can do heaps of stuff with Cmakex.")
    nl() # This is a shorthand for a newline. You can also give it a count, to add multiple newlines.

    set(:do_thing, true) # Setting variables is easy.
    nl(2) # Two newlines! :O

    cond_if(:do_thing) # Using them for conditional logic is easy, too.
      message("Maybe we should do something.")
    cond_else()
      message("Although, I prefer not to!")
    cond_endif()
    nl()

    comment("... This is a sneaky comment! Don't mind me.")

    nl()

    # If we wanted to add a build target, we can do so like this:
    # add_library(project_name, [
    #   :SHARED,
    #   "test.cpp" # <- Paths are relative to #{Mix.Project.config()[:app]}/natives/#{project_name}/
    # ])

    # Adding things to the target can be done like this:
    # target_include_directories(project_name, [:PRIVATE, "${nifpp_SOURCE_DIR}"])

    # In short, they accept a list of args which are interpolated into the parameters of the Cmake.
    # The above would end up looking like:
    # target_include_directories(#{project_name} PRIVATE ${nifpp_SOURCE_DIR})

    # Functions are a little tricky, since Cmakex stamps and doesn't return anything.
    # However, using actual magic we can define a function for our CMakeLists like so:
    my_function =
      function my_function(:left, :right) do
        message("Called our function!")
        message("${left}")
        message("${right}")
      end
    # You don't have to name them :left and :right, either; that's just for the example

    nl()

    # Later on, 'invoking it' like this:
    my_function.("bacon", "eggs")

    # Of course, these are hyper generic.
    my_function.(5, cmake_binary_dir())
    nl()

    # You can add a dependency to the project by using FetchContent.
    # If you don't need to add any external dependencies, you don't need to worry about this.
    # As an example, here's a lovely C++ NIF wrapper library named nifpp:

    include_fetch_content() # <- Just call this once, below your `project()` call but above it's usage.

    # We declare that we are using nifpp; this will download the git repo.
    fetch_content_declare(:nifpp, [
      :REQUIRED,
      GIT_REPOSITORY: "https://github.com/goertzenator/nifpp.git",
      GIT_PROGRESS: true
    ])
    nl()

    # For targets to be able to use the package we downloaded, we can compile it and make it a valid target with:
    fetch_content_make_available(:nifpp) # nifpp doesn't need to compile though, it's header-only :)
    nl()

    # We can then add the target header to our executable / library using the following:
    # target_include_directories(project_name, [:PRIVATE, "${nifpp_SOURCE_DIR}"])

    # .. But we don't have a target just yet, of course.

    # For compiled fetched content, we can link them very easily:
    # target_link_libraries(project_name, [:some_fetched_content])

    ### END examples

    # Finally, add ERTS to the build target, make the cmake file and build.
    # Note: add_erts_to_target calls target_include_directory, which requires a valid target.
    # Look into cmakex/templates/add.ex for some options, or roll your own.

    # add_erts_to_target(project_name)
    """
  end
end
