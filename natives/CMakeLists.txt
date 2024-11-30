cmake_minimum_required(VERSION 3.10)
project(cmake_example)

# REGION:Elixir & Erlang Environment
# Add Mix environment configurations
set(MIX_TARGET host)
set(MIX_ENV dev)
set(MIX_BUILD_PATH /run/media/fatigue/hdd/Projects/cmakex/_build/dev)
set(MIX_APP_PATH /run/media/fatigue/hdd/Projects/cmakex/_build/dev/lib/cmakex)
set(MIX_COMPILE_PATH /run/media/fatigue/hdd/Projects/cmakex/_build/dev/lib/cmakex/ebin)
set(MIX_CONSOLIDATION_PATH /run/media/fatigue/hdd/Projects/cmakex/_build/dev/lib/cmakex/consolidated)
set(MIX_DEPS_PATH /run/media/fatigue/hdd/Projects/cmakex/deps)
set(MIX_MANIFEST_PATH /run/media/fatigue/hdd/Projects/cmakex/_build/dev/lib/cmakex/.mix)

# Rebar naming
set(ERL_EI_LIBDIR /usr/lib/erlang/usr/lib)
set(ERL_EI_INCLUDE_DIR /usr/lib/erlang/usr/include)

# erlang.mk naming
set(ERTS_INCLUDE_DIR /usr/lib/erlang/erts-15.1.2/include)
set(ERL_INTERFACE_LIB_DIR /usr/lib/erlang/usr/lib)
set(ERL_INTERFACE_INCLUDE_DIR /usr/lib/erlang/usr/include)

# Disable default erlang values
unset(BINDIR)
unset(ROOTDIR)
unset(PROGNAME)
unset(EMU)
# END_REGION:Elixir & Erlang Environment

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY /run/media/fatigue/hdd/Projects/cmakex/priv/cmake_example)
function(get_raylib )
	include(FetchContent)
	FetchContent_Declare(
		raylib
		GIT_REPOSITORY "https://github.com/raysan5/raylib.git"
		GIT_TAG "5.5"
		GIT_PROGRESS TRUE
		REQUIRED
	)
	FetchContent_MakeAvailable(raylib)
	target_compile_options(raylib BEFORE PUBLIC -fPIC --std=c++11)
	target_link_libraries(cmake_example raylib)
endfunction(get_raylib)

add_library(cmake_example SHARED hello.cpp)
get_raylib()

set(CMAKE_CXX_FLAGS -fexceptions)

target_include_directories(cmake_example BEFORE PUBLIC ${ERTS_INCLUDE_DIR})

