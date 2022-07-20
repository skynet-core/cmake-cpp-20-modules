# C++20 Modules with CMake
## Minimal template to start hacking with C++20 modules using CMake build system.

## compilations 

    cmake --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_C_COMPILER:FILEPATH=$(which $CC) -DCMAKE_CXX_COMPILER:FILEPATH=$(which $CXX) -S./ -B./build -G "Unix Makefiles"

    cmake --build ./build --config Debug --target all -j 18 --

## Well Known Issues

1. Clang does not have an option to pre-compile system headers like GCC does, so it is recommended to include headers
    in module section so it remain compatible with GCC.

# TODO List:

- [ ] MacOS support
- [ ] Windows MSVC support
- [ ] Windows MINGW support



// clang++  -std=c++20 -fmodules -fimplicit-modules -fimplicit-module-maps -fprebuilt-module-path=. -x c++-module ./another.ixx -Xclang -emit-module-interface --precompile -o ./another.pcm

// clang++  -std=c++20 -fmodules -fimplicit-modules -fimplicit-module-maps -fprebuilt-module-path=. -x c++-module ./root.ixx -Xclang -emit-module-interface --precompile -o ./root.pcm

// clang++  -std=c++20 -fmodules -fimplicit-modules -fimplicit-module-maps -fprebuilt-module-path=. -fmodule-file=./root.pcm -c ./root.cpp

// clang++  -std=c++20 -fmodules -fimplicit-modules -fimplicit-module-maps -fprebuilt-module-path=. -fmodule-file=./another.pcm -c ./another.cpp

// clang++  -std=c++20 -fmodules -fimplicit-modules -fimplicit-module-maps -fprebuilt-module-path=. ./another.o ./root.o ./main.cpp -o main 