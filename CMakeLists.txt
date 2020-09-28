cmake_minimum_required(VERSION 3.10)

project(
  cpp-template
  VERSION 0.1.0
  LANGUAGES C CXX)

if(CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?Clang")
  option(USE_LIBCXX "Use libc++" OFF)
endif()

option(BUILD_TESTING "Build test suite" OFF)
option(FORMAT "Format code" OFF)
option(CLANG_TIDY "Analyze code with clang-tidy" OFF)

set(SANITIZER
    ""
    CACHE
      STRING
      "Build with a sanitizer. Options are: Address, Thread, Memory, Undefined and Address;Undefined"
)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(Check)
include(ClangTidy)
include(CompilerOptions)
include(Sanitizer)

set(PROGRAM_NAME test-program)
set(LIB_NAME lib${PROGRAM_NAME})
set(TEST_PROGRAM_NAME ${PROGRAM_NAME}-gtest)

add_subdirectory(src)

if(BUILD_TESTING)
  enable_testing()
  add_subdirectory(tests)
endif()

include(Format)
include(Install)
