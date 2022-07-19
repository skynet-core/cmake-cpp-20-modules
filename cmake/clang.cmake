# add_custom_target( std_modules ALL COMMAND ${CMAKE_CXX_COMPILER} -c -std=c++20
# -fmodules-ts -x c++-system-header ${CPP_STD_MODULES} )
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


file(GLOB OBJECTS "*.cxx" "*.ixx")
set(MODULES ${OBJECTS})
set(PREBUILD_MODULES_PATH
    ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/modules_lib.dir)
list(TRANSFORM OBJECTS REPLACE ".*/" "/")
list(TRANSFORM OBJECTS PREPEND ${PREBUILD_MODULES_PATH})
list(TRANSFORM OBJECTS REPLACE ".(cxx|ixx)$" ".o")

file(MAKE_DIRECTORY ${PREBUILD_MODULES_PATH})
add_custom_target(
  modules_1 ALL
  COMMAND ${CMAKE_CXX_COMPILER} -std=c++20 -fmodules-ts -Xclang
          -emit-module-interface -c ${MODULES}
  SOURCES ${MODULES}
  WORKING_DIRECTORY ${PREBUILD_MODULES_PATH})

add_custom_target(
  modules_2 ALL
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/rename.cmake
  DEPENDS modules_1
  WORKING_DIRECTORY ${PREBUILD_MODULES_PATH})

# compile modules ...
add_custom_target(
  modules ALL
  COMMAND ${CMAKE_CXX_COMPILER} -std=c++20 -fmodules-ts -fprebuilt-module-path=${PREBUILD_MODULES_PATH} -c ${MODULES}
  SOURCES ${MODULES}
  BYPRODUCTS ${OBJECTS}
  DEPENDS modules_2
  WORKING_DIRECTORY ${PREBUILD_MODULES_PATH})

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/lib.cpp "")
add_library(modules_lib OBJECT ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/lib.cpp)
target_compile_features(modules_lib PRIVATE cxx_std_20)
target_compile_options(modules_lib PRIVATE -fmodules-ts -fprebuilt-module-path=${PREBUILD_MODULES_PATH})
target_link_libraries(modules_lib PRIVATE ${OBJECTS})
add_dependencies(modules_lib modules)

add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(${PROJECT_NAME} PRIVATE -fmodules-ts -fprebuilt-module-path=${PREBUILD_MODULES_PATH})
target_link_libraries(${PROJECT_NAME} PRIVATE modules_lib)
