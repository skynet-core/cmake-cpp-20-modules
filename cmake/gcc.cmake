set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_custom_target(
  std_modules ALL
  COMMAND ${CMAKE_CXX_COMPILER} -c -std=c++20 -fmodules-ts -x c++-system-header
          ${CPP_STD_MODULES})

file(GLOB OBJECTS "*.cxx" "*.ixx")

add_library(modules_lib OBJECT ${OBJECTS})

target_compile_features(modules_lib PRIVATE cxx_std_20)
target_compile_options(
  modules_lib PRIVATE -fmodules-ts -fno-module-lazy -flang-info-module-cmi
                      -flang-info-include-translate)
add_dependencies(modules_lib std_modules)

add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(${PROJECT_NAME} PRIVATE -fmodules-ts)
target_link_libraries(${PROJECT_NAME} PRIVATE modules_lib)
add_dependencies(${PROJECT_NAME} modules_lib)
