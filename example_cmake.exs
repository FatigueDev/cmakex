use Cmakex, project_name: :cmake_example, cmake_minimum_required: "3.10"

raylib_github = "https://github.com/raysan5/raylib.git"
raylib_tab = 5.5

get_raylib =
    function get_raylib() do
      ~m"include(FetchContent)"n
      ~m"FetchContent_Declare("nu
        ~m"raylib"n
        ~m/GIT_REPOSITORY "#{raylib_github}"/n
        ~m/GIT_TAG "#{raylib_tab}"/n
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

create_cmake_file("native_c")
