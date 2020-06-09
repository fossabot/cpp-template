cmake_minimum_required(VERSION 3.13)

project(
  cpp-template
  VERSION 0.1
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

set(LIB_NAME ${PROJECT_NAME}_lib)
set(PROGRAM_NAME ${PROJECT_NAME})
set(TEST_PROGRAM_NAME ${PROJECT_NAME}_test)
set(COVERAGE_RUN_ARGS "")

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/lib/*.cpp)
file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS test/*.cpp)
file(GLOB_RECURSE CLANG_FORMAT_SOURCES CONFIGURE_DEPENDS include/*.h src/*.cpp
     test/*.cpp)
file(GLOB_RECURSE CMAKE_FORMAT_SOURCES CONFIGURE_DEPENDS cmake/*.cmake
     CMakeLists.txt)

include_directories(include)
add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")

add_library(${LIB_NAME} SHARED ${SOURCES})
add_executable(${PROGRAM_NAME} src/main.cpp)
target_link_libraries(${PROGRAM_NAME} ${LIB_NAME})

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

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)

add_custom_target(uninstall COMMAND rm
                                    ${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME})
