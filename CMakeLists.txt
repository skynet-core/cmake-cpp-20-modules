cmake_minimum_required(VERSION 3.20)

project(playground)

set(CMAKE_VERBOSE_MAKEFILE ON)

if(EXISTS "std_modules.txt")
  file(STRINGS "std_modules.txt" CPP_STD_MODULES)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(MODULES_LIB
    "modules_lib"
    CACHE STRING "modules_lib")

file(GLOB MOD_SOURCES "*.cpp" "*.cxx" "*.cppm")
# exclude main.cpp
list(FILTER MOD_SOURCES EXCLUDE REGEX ".*main.cpp$")
list(LENGTH MOD_SOURCES LEN_MOD_SOURCES)

set(PREBUILD_MODULES_PATH
    ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${MODULES_LIB}.dir)
file(MAKE_DIRECTORY ${PREBUILD_MODULES_PATH})

string(TOUPPER ${CMAKE_CXX_COMPILER_ID} CMAKE_CXX_COMPILER_ID)
if(CMAKE_CXX_COMPILER_ID STREQUAL "CLANG")
  include(cmake/clang.cmake)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  include(cmake/gcc.cmake)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "INTEL")
  message(FATAL_ERROR "not implemented yet")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  message(FATAL_ERROR "not implemented yet")
endif()
