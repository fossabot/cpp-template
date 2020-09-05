cmake_minimum_required(VERSION 3.10)

project(
  cpp-template
  VERSION 0.1.0
  LANGUAGES CXX)

# ===============
# === Options ===
# ===============

option(BUILD_TESTING "BuildING test suite" ON)
option(CLANG_TIDY "Analyze code with clang-tidy" OFF)
option(FORMAT "Foramt code" OFF)

# ===============
# === Include ===
# ===============

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(Check)
include(CompilerOptions)

if(CLANG_TIDY)
  include(ClangTidy)
endif()

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

# === Target: test ===

include(CTest)

if(BUILD_TESTING)
  message(STATUS "Building test suite")
  enable_testing()
  add_subdirectory(tests)
endif()

# === Target: foramt ===
if(FORMAT)
  include(Format)
endif()

# ===============
# === Install ===
# ===============

install(TARGETS ${PROGRAM_NAME} DESTINATION bin)
