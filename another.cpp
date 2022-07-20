module;
#include <iostream>
module another;

void SomeClass::HelloWorld() const {
    std::cout << "Hello, World!" << std::endl;
    std::cerr << "Hello, World!!" << std::endl;
}
