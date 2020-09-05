#include <cstdint>
#include <iostream>
#include <vector>

#include "lib.h"

int main()
{
    std::vector<std::int32_t> v;
    v.push_back(1);
    v.push_back(2);
    v.push_back(3);

    std::cout << add(1, 2) << '\n';
}
