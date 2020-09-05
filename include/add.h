#pragma once

#include <cstdint>

std::int32_t add(std::int32_t lhs, std::int32_t rhs);

inline std::int32_t add2(std::int32_t lhs, std::int32_t rhs) {
  return lhs + rhs;
}

struct Bar {
  Bar() {}
};
