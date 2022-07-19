cmake_minimum_required(VERSION 3.20)

project(playground)

set(CPP_STD_MODULES
    "iostream"
    CACHE STRING "std_modules")

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
