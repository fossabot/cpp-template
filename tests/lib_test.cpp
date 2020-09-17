#include <gtest/gtest.h>

#include "lib.h"

TEST(LibTest, test1) {
  Bar bar;
  bar.fun();

  ASSERT_EQ(add(1, 2), 3);
}

TEST(LibTest, test2) { ASSERT_EQ(add(1, 2), 3); }

TEST(LibTest, test3) { ASSERT_EQ(add(1, 2), 3); }

TEST(LibTest, test4) { ASSERT_EQ(add(1, 2), 3); }

TEST(LibTest, test5) { ASSERT_EQ(add(1, 2), 3); }

TEST(LibTest, test6) { ASSERT_EQ(add(1, 2), 3); }
