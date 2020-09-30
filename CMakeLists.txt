cmake_minimum_required(VERSION 3.10)

project(
  cpp-template
  VERSION 0.1.0
  LANGUAGES C CXX)

if(CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?Clang")
  option(USE_LIBCXX "Use libc++" OFF)
endif()

option(BUILD_SHARED "Build shared library" OFF)
option(BUILD_TESTING "Build test suite" OFF)
option(BENCHMARK "Enable benchmarking" OFF)
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
set(LIB_NAME add)
set(TEST_PROGRAM_NAME test-gtest)
set(BENCHMARK_PROGRAM_NAME test-benchmark)

file(GLOB_RECURSE LIB_SOURCES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/src/*.cpp)
set(SOURCES ${CMAKE_SOURCE_DIR}/src/main.cpp)
list(REMOVE_ITEM LIB_SOURCES ${SOURCES})

add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")

if(BUILD_SHARED)
  add_library(${LIB_NAME} SHARED ${LIB_SOURCES})
else()
  add_library(${LIB_NAME} STATIC ${LIB_SOURCES})
endif()

add_library(${LIB_NAME}::${LIB_NAME} ALIAS ${LIB_NAME})

target_include_directories(
  ${LIB_NAME} PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
                     "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
set_target_properties(${LIB_NAME} PROPERTIES VERSION 0.1.0 SOVERSION 0)
set_target_properties(${LIB_NAME} PROPERTIES DEBUG_POSTFIX d)

add_executable(${PROGRAM_NAME} ${SOURCES})
target_link_libraries(${PROGRAM_NAME} PRIVATE ${LIB_NAME})

if(BUILD_TESTING)
  enable_testing()

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
endif()

if(BENCHMARK)
  message(STATUS "Enable benchmarking")

  file(GLOB_RECURSE BENCHMARK_SOURCES CONFIGURE_DEPENDS
       ${CMAKE_SOURCE_DIR}/benchmark/*.cpp)

  find_package(benchmark REQUIRED)

  add_executable(${BENCHMARK_PROGRAM_NAME} ${BENCHMARK_SOURCES})
  target_link_libraries(${BENCHMARK_PROGRAM_NAME} PRIVATE ${LIB_NAME}
                                                          benchmark::benchmark)
endif()

include(Format)
include(Install)
