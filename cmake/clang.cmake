function(prepare_module source_file target)
  string(REGEX REPLACE "\\.(.*)$" "" MODE_IFACE "${source_file}")
  if(EXISTS "${MODE_IFACE}.ixx")
    set(MODE_IFACE "${MODE_IFACE}.ixx")
  else()
    set(MODE_IFACE "${MODE_IFACE}.cxx")
  endif()

  get_filename_component(MOD_IFACE_NAME "${MODE_IFACE}" NAME_WLE)

  add_library(${MOD_IFACE_NAME}_obj OBJECT "${source_file}")
  target_link_libraries(${target} PRIVATE ${MOD_IFACE_NAME}_obj)
  add_dependencies(${target} ${MOD_IFACE_NAME}_obj)
  set(LINK_TARGETS "${LINK_TARGETS} ${MOD_IFACE_NAME}_obj")

  target_compile_features(${MOD_IFACE_NAME}_obj PRIVATE cxx_std_20)

  if(EXISTS "${MODE_IFACE}")
    message(STATUS "adding custom target for ${MOD_IFACE_NAME}")
    set(MOD_IFACE_OUT_NAME "${MOD_IFACE_NAME}.pcm")

    add_custom_target(
      ${MOD_IFACE_NAME}_iface ALL
      COMMAND
        ${CMAKE_CXX_COMPILER} -std=c++20 -fmodules -fimplicit-modules
        -fprebuilt-module-path=${PREBUILD_MODULES_PATH} -fimplicit-module-maps
        -x c++-module ${MODE_IFACE} -Xclang -emit-module-interface --precompile
        -o ${PREBUILD_MODULES_PATH}/${MOD_IFACE_OUT_NAME}
      SOURCES ${MODE_IFACE}
      WORKING_DIRECTORY ${PREBUILD_MODULES_PATH})

    add_dependencies(${MOD_IFACE_NAME}_obj ${MOD_IFACE_NAME}_iface)
    target_compile_options(
      ${MOD_IFACE_NAME}_obj
      PRIVATE -fmodules -fimplicit-modules -fimplicit-module-maps
              -fprebuilt-module-path=${PREBUILD_MODULES_PATH}
              -fmodule-file=${PREBUILD_MODULES_PATH}/${MOD_IFACE_OUT_NAME})
  else()
    target_compile_options(
      ${MOD_IFACE_NAME}_obj
      PRIVATE -fmodules -fimplicit-modules -fimplicit-module-maps
              -fprebuilt-module-path=${PREBUILD_MODULES_PATH})
  endif()

  message(STATUS "FILE ${MODE_IFACE}")
endfunction()

set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
set (CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")

add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(
  ${PROJECT_NAME} PRIVATE -fmodules -fimplicit-modules -fimplicit-module-maps
                          -fprebuilt-module-path=${PREBUILD_MODULES_PATH})

list(FILTER MOD_SOURCES EXCLUDE REGEX ".*\\.(i|c)xx$")
foreach(file_path IN LISTS MOD_SOURCES)
  message(STATUS "info ${file_path}")
  prepare_module(${file_path} ${PROJECT_NAME})
endforeach()
