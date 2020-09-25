cmake_minimum_required(VERSION 3.10)

project(
  cpp-template
  VERSION 0.1.0
  LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(Check)
include(CompilerOptions)

option(BUILD_TESTING "Build test suite" ON)
option(FORMAT "Format code" OFF)
option(CLANG_TIDY "Analyze code with clang-tidy" OFF)
set(SANITIZER
    ""
    CACHE STRING
          "Build with a sanitizer. Options are: Address, Thread, Undefined")

include(ClangTidy)
include(Sanitizer)

set(PROGRAM_NAME test-program)
set(LIB_NAME lib${PROGRAM_NAME})
set(TEST_PROGRAM_NAME ${PROGRAM_NAME}-gtest)

file(GLOB_RECURSE LIB_SOURCES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/src/*.cpp)
set(SOURCES ${CMAKE_SOURCE_DIR}/src/main.cpp)
list(REMOVE_ITEM LIB_SOURCES ${SOURCES})

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS
     ${CMAKE_SOURCE_DIR}/tests/*.cpp)

file(GLOB_RECURSE CLANG_FORMAT_SOURCES CONFIGURE_DEPENDS
     ${CMAKE_SOURCE_DIR}/include/*.h ${CMAKE_SOURCE_DIR}/src/*.cpp
     ${CMAKE_SOURCE_DIR}/tests/*.cpp)
file(GLOB_RECURSE CMAKE_FORMAT_SOURCES CONFIGURE_DEPENDS
     ${CMAKE_SOURCE_DIR}/cmake/*.cmake ${CMAKE_SOURCE_DIR}/CMakeLists.txt)

add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")

add_library(${LIB_NAME} OBJECT ${LIB_SOURCES})
target_include_directories(${LIB_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)

add_executable(${PROGRAM_NAME} ${SOURCES})
target_link_libraries(${PROGRAM_NAME} PRIVATE ${LIB_NAME})

if(BUILD_TESTING)
  message(STATUS "Build test suite")

  option(COVERAGE "Build test suite with coverage information" OFF)
  option(VALGRIND "Execute test suite with Valgrind" OFF)

  include(Coverage)
  include(Valgrind)

  enable_testing()
  find_package(GTest REQUIRED)

  add_executable(${TEST_PROGRAM_NAME} ${TEST_SOURCES})
  target_link_libraries(${TEST_PROGRAM_NAME} PRIVATE ${LIB_NAME} GTest::gtest)
  gtest_discover_tests(${TEST_PROGRAM_NAME})
endif()

include(Format)

install(TARGETS ${PROGRAM_NAME} DESTINATION bin)
