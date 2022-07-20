# C++20 Modules with CMake
## Minimal template to start hacking with C++20 modules using CMake build system.

## compilations 

    cmake --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_C_COMPILER:FILEPATH=$(which $CC) -DCMAKE_CXX_COMPILER:FILEPATH=$(which $CXX) -S./ -B./build -G "Unix Makefiles"

    cmake --build ./build --config Debug --target all -j 18 --

## Well Known Issues

1. Clang does not have an option to pre-compile system headers like GCC does, so it is recommended to include headers
    in module section so it remain compatible with GCC.

2. GCC fails to compile modules with dependencies on first iteration :(

# TODO List:

- [ ] MacOS support
- [ ] Windows MSVC support
- [ ] Windows MINGW support
