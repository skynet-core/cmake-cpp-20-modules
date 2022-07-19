add_custom_target(
  std_modules ALL
  COMMAND ${CMAKE_CXX_COMPILER} -c -std=c++20 -fmodules-ts -x c++-system-header
          ${CPP_STD_MODULES}
  )

file(GLOB OBJECTS "*.cxx" "*.ixx")
set(MODULES ${OBJECTS})
list(TRANSFORM OBJECTS REPLACE ".*/" "/")
list(TRANSFORM OBJECTS PREPEND ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/modules_lib.dir)
list(TRANSFORM OBJECTS APPEND ".o")

add_custom_target(
  modules ALL
  COMMAND ${CMAKE_CXX_COMPILER} -g -c -std=c++20 -fmodules-ts ${MODULES}
  SOURCES ${MODULES}
  BYPRODUCTS ${OBJECTS}
  DEPENDS std_modules
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})


file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp "")
add_library(modules_lib OBJECT ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp)
target_compile_features(modules_lib PRIVATE cxx_std_20)
target_compile_options(modules_lib PRIVATE -fmodules-ts)
target_link_libraries(modules_lib PRIVATE ${OBJECTS})
add_dependencies(modules_lib modules)


add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(${PROJECT_NAME} PRIVATE -fmodules-ts)
target_link_libraries(${PROJECT_NAME} PRIVATE modules_lib)
add_dependencies(${PROJECT_NAME} modules_lib)
