message(STATUS "Build test suite")

option(COVERAGE "Build test suite with coverage information" OFF)
option(VALGRIND "Execute test suite with Valgrind" OFF)

include(Coverage)
include(Valgrind)

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS
     ${CMAKE_SOURCE_DIR}/tests/*.cpp)

find_package(GTest REQUIRED)

add_executable(${TEST_PROGRAM_NAME} ${TEST_SOURCES})
target_link_libraries(${TEST_PROGRAM_NAME} PRIVATE ${LIB_NAME} GTest::gtest)
gtest_discover_tests(${TEST_PROGRAM_NAME})
