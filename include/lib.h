#pragma once

#include <cstdint>

struct Bar {
    Bar() = default;
    void fun() {}
};

std::int32_t add(std::int32_t lhs, std::int32_t rhs);
