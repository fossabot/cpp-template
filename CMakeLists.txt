cmake_minimum_required(VERSION 3.13)

project(
  cpp-template
  VERSION 0.1.0
  LANGUAGES CXX)

if((CMAKE_BUILD_TYPE STREQUAL "Debug") OR (CMAKE_BUILD_TYPE STREQUAL
                                           "RelWithDebInfo"))
  # Address Memory Thread None
  set(SANITIZER "Address")
else()
  set(SANITIZER "None")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(Check)
include(ClangTidy)
include(CompilerOptions)
include(Sanitizers)

set(PROGRAM_NAME add)
set(TEST_PROGRAM_NAME add-test)
set(TEST_RUN_ARGS "")

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.cpp)
file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS tests/*.cpp)
file(GLOB_RECURSE CLANG_FORMAT_SOURCES CONFIGURE_DEPENDS include/*.h src/*.cpp
     tests/*.cpp)
file(GLOB_RECURSE CMAKE_FORMAT_SOURCES CONFIGURE_DEPENDS cmake/*.cmake
     CMakeLists.txt)
list(REMOVE_ITEM SOURCES ${CMAKE_SOURCE_DIR}/src/main.cpp)

include_directories(include)
add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")

add_executable(${PROGRAM_NAME} ${SOURCES} src/main.cpp)

enable_testing()
find_package(GTest REQUIRED)
add_executable(${TEST_PROGRAM_NAME} ${SOURCES} ${TEST_SOURCES})
target_link_libraries(${TEST_PROGRAM_NAME} ${GTEST_LIBRARIES})
gtest_discover_tests(${TEST_PROGRAM_NAME})

include(Coverage)
if((CMAKE_BUILD_TYPE MATCHES "Debug") OR (CMAKE_BUILD_TYPE MATCHES
                                          "RelWithDebInfo"))
  include(Format)
endif()

install(TARGETS ${PROGRAM_NAME} RUNTIME DESTINATION bin)
