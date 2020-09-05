cmake_minimum_required(VERSION 3.10)

project(
  cpp-template
  VERSION 0.1.0
  LANGUAGES CXX)

# ===============
# === Include ===
# ===============

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(Check)
include(CompilerOptions)
include(ClangTidy)
include(CTest)

# ===============
# === Options ===
# ===============

option(BUILD_TESTING "Build test suite" ON)
option(CLANG_TIDY "Analyze code with clang-tidy" OFF)
option(FORMAT "Format code" OFF)

# =============
# === Files ===
# =============

file(GLOB_RECURSE LIB_SOURCES CONFIGURE_DEPENDS src/*.cpp)
set(SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp)
list(REMOVE_ITEM LIB_SOURCES ${SOURCES})

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS tests/*.cpp)

file(GLOB_RECURSE CLANG_FORMAT_SOURCES CONFIGURE_DEPENDS include/*.h src/*.cpp
     tests/*.cpp)
file(GLOB_RECURSE CMAKE_FORMAT_SOURCES CONFIGURE_DEPENDS cmake/*.cmake
     CMakeLists.txt)

# ===============
# === Targets ===
# ===============

set(LIB_NAME lib${PROJECT_NAME})
set(PROGRAM_NAME ${PROJECT_NAME})
set(TEST_PROGRAM_NAME ${PROJECT_NAME}-test)

add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")

# === Target: lib ===

add_library(${LIB_NAME} OBJECT ${LIB_SOURCES})
target_include_directories(${LIB_NAME} PUBLIC include)

# === Target: program ===

add_executable(${PROGRAM_NAME} ${SOURCES})
target_link_libraries(${PROGRAM_NAME} PRIVATE ${LIB_NAME})

if(BUILD_TESTING)
  message(STATUS "Building test suite")

  # ===============
  # === Options ===
  # ===============

  option(COVERAGE "Build test suite with coverage information" OFF)
  option(VALGRIND "Execute test suite with Valgrind" OFF)

  set(SANITIZER
      ""
      CACHE STRING
            "Compile with a sanitizer. Options are: Address, Thread, Undefined")

  enable_testing()
  find_package(GTest REQUIRED)

  # === Target: test ===

  add_executable(${TEST_PROGRAM_NAME} ${TEST_SOURCES})
  target_link_libraries(${TEST_PROGRAM_NAME} PRIVATE ${LIB_NAME}
                                                     ${GTEST_LIBRARIES})
  gtest_discover_tests(${TEST_PROGRAM_NAME})

  include(Coverage)
  include(Sanitizers)
  include(Valgrind)
endif()

# === Target: format ===
include(Format)

# ===============
# === Install ===
# ===============

install(TARGETS ${PROGRAM_NAME} DESTINATION bin)
