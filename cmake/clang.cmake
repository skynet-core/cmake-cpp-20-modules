add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(
  ${PROJECT_NAME} PRIVATE -fmodules-ts
                          -fprebuilt-module-path=${PREBUILD_MODULES_PATH})

if(${LEN_MOD_SOURCES} GREATER 0)
  set(MODULES ${MOD_SOURCES})

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

  add_library(${MODULES_LIB} OBJECTS ${MODULES})
  target_compile_features(${MODULES_LIB} PRIVATE cxx_std_20)
  target_compile_options(
    ${MODULES_LIB} PRIVATE -fmodules-ts
                        -fprebuilt-module-path=${PREBUILD_MODULES_PATH})
  add_dependencies(${MODULES_LIB} modules_2)

  target_link_libraries(${PROJECT_NAME} PRIVATE ${MODULES_LIB})

endif()
