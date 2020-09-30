#include <gtest/gtest.h>

#include "add.h"

TEST(AddTest, test1) {
  Bar bar;
  bar.get_val();

  ASSERT_EQ(add(1, 2), 3);
}

TEST(AddTest, test2) { ASSERT_EQ(add(1, 2), 3); }

TEST(AddTest, test3) { ASSERT_EQ(add(1, 2), 3); }

TEST(AddTest, test4) { ASSERT_EQ(add(1, 2), 3); }

TEST(AddTest, test5) { ASSERT_EQ(add(1, 2), 3); }

TEST(AddTest, test6) { ASSERT_EQ(add(1, 2), 3); }
