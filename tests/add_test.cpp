#include <gtest/gtest.h>

#include "add.h"

TEST(add_test, test1) {
  Bar bar;
  ASSERT_EQ(add(1, 2), 3);
}
