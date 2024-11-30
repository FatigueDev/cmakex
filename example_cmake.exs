use Cmakex, project_name: :cmake_example, cmake_minimum_required: "3.10"

raylib_github = "https://github.com/raysan5/raylib.git"
raylib_tag = 5.5
example_output_path = Path.join([File.cwd!(), "priv", Atom.to_string(project_name)])

set(:CMAKE_LIBRARY_OUTPUT_DIRECTORY, example_output_path)

get_raylib =
    function get_raylib() do
      ~m"include(FetchContent)"n
      ~m"FetchContent_Declare("nu
        ~m"raylib"n
        ~m/GIT_REPOSITORY "#{raylib_github}"/n
        ~m/GIT_TAG "#{raylib_tag}"/n
        ~m"GIT_PROGRESS TRUE"n
        ~m"REQUIRED"n
      ~m")"nd
      ~m"FetchContent_MakeAvailable(raylib)"n
      target_compile_options(:raylib, :BEFORE, [PUBLIC: ["-fPIC", "--std=c++11"]])
      target_link_libraries(:cmake_example, [:raylib])
    end

newline()

add_library(project_name, :SHARED, ["hello.cpp"])
get_raylib.()

newline()
set(:CMAKE_CXX_FLAGS, "-fexceptions")
newline()
target_include_directories(project_name, :BEFORE, [PUBLIC: ["${ERTS_INCLUDE_DIR}"]])
# target_compile_options(project_name, :BEFORE, [PUBLIC: ["-fPIC", "-std=c++20", "-O3", "-ansi", "-pedantic", "-Wall", "-Wno-unused-parameter", "-Wextra"]])
newline()



create_cmake_file("natives")

should_build = case IO.getn("CMakeLists.txt has been created!\nWould you like to configure & build to `priv`? (Y/n)\n", 1) do
  "n" -> false
  "N" -> false
  _ -> true
end

if should_build do

  File.mkdir_p(example_output_path)

  exit_status = Mix.Shell.cmd("cmake -S natives _build_natives --fresh --log-level=VERBOSE", fn result ->
    IO.binwrite(result)
  end)

  if exit_status == 0 do
    dbg "Running build now."
    Mix.Shell.cmd("cmake --build _build_natives -v", fn iodata ->
      IO.binwrite(iodata)
    end)
  end
end
