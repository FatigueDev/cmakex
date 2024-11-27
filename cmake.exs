use Cmakex, cmake_minimum_required: "3.10"

add_mix_dependency(
  :raylib,
  "You must use tag 5.5.0 of Raylib.\nHere's the git: https://github.com/raysan5/raylib/tree/5.5"
)
ensure_mix_dependencies()

deps_path = Mix.Project.deps_path()
project_name = :hello

project(project_name, languages: ["CXX"])
set(:RAYLIB_VERSION, 5.5)
add_subdirectory(Path.join([deps_path, "raylib"]), :raylib, [:EXCLUDE_FROM_ALL])
add_library(project_name, :SHARED, ["hello.cpp"])
set(:CMAKE_CXX_FLAGS, "-fexceptions")
target_compile_options("raylib", :BEFORE, [PUBLIC: ["-fPIC", "-std=c++20"]])
target_compile_options(project_name, :BEFORE, [PUBLIC: ["-fPIC", "-std=c++20", "-O3", "-ansi", "-pedantic", "-Wall", "-Wno-unused-parameter", "-Wextra"]])
target_include_directories(project_name, :BEFORE, [PUBLIC: ["${ERTS_INCLUDE_DIR}"]])
target_link_libraries(project_name, ["raylib"])

create_cmake_file("priv/native_c")
