#include <gtest/gtest.h>

#include "lib.h"

TEST(lib_test, test1)
{
    Bar bar;
    bar.fun();

    ASSERT_EQ(add(1, 2), 3);
}

TEST(lib_test, test2)
{
    ASSERT_EQ(add(1, 2), 3);
}

TEST(lib_test, test3)
{
    ASSERT_EQ(add(1, 2), 3);
}

TEST(lib_test, test4)
{
    ASSERT_EQ(add(1, 2), 3);
}

TEST(lib_test, test5)
{
    ASSERT_EQ(add(1, 2), 3);
}

TEST(lib_test, test6)
{
    ASSERT_EQ(add(1, 2), 3);
}
