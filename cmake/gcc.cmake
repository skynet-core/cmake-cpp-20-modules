list(LENGTH CPP_STD_MODULES NUM_STD_MODULES)
if(${NUM_STD_MODULES} GREATER 0)
  add_custom_target(
    std_modules ALL COMMAND ${CMAKE_CXX_COMPILER} -c -std=c++20 -fmodules-ts -x
                            c++-system-header ${CPP_STD_MODULES})
endif()

add_executable(${PROJECT_NAME} main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_options(${PROJECT_NAME} PRIVATE -fmodules-ts)

if(${LEN_MOD_SOURCES} GREATER 0)
  add_library(${MODULES_LIB} OBJECT ${MOD_SOURCES})

  target_compile_features(${MODULES_LIB} PRIVATE cxx_std_20)
  target_compile_options(
    ${MODULES_LIB} PRIVATE -fmodules-ts -fno-module-lazy -flang-info-module-cmi
                           -flang-info-include-translate)
  if(${NUM_STD_MODULES} GREATER 0)
    add_dependencies(${MODULES_LIB} std_modules)
  endif()
  add_dependencies(${PROJECT_NAME} ${MODULES_LIB})

  target_link_libraries(${PROJECT_NAME} PRIVATE ${MODULES_LIB})

endif()
