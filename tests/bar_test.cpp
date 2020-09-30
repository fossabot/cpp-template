#include <gtest/gtest.h>

#include "bar.h"

TEST(BarTest, test1) {
  Bar bar;
  ASSERT_EQ(bar.get_val(), 0);
}

TEST(BarTest, test2) {
  Bar bar{42};
  ASSERT_EQ(bar.get_val(), 42);
}
