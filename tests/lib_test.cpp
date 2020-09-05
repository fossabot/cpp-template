#include <gtest/gtest.h>

#include "lib.h"

TEST(lib_test, test1) {
  Bar bar;

  ASSERT_EQ(add(1, 2), 3);
}
