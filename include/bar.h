/// \file bar.h

#pragma once

#include <cstdint>

/// test struct bar
class Bar {
 public:
  /// Default constructor
  Bar() = default;
  /**
   * @brief A constructor
   * @param val Used to initialize members
   */
  explicit Bar(std::int32_t val) : val_{val} {}
  /**
   * @brief A member fun
   * @return return val
   */
  std::int32_t get_val() const { return val_; }

 private:
  std::int32_t val_{};
};
