#include <iostream>

#include <add.h>
#include <bar.h>
#include <sub.h>

int main() {
  std::cout << add(1, 2) << '\n';
  std::cout << sub(5, 4) << '\n';
  std::cout << Bar{42}.get_val() << '\n';
}
