module;

#include <iostream>

export module bye;


export void bye_world() {
  auto name = "EARTH!";
  std::cout << "Bye, " << name << std::endl;
}