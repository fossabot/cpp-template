cmake_minimum_required(VERSION 3.13)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified")
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Choose the type of build" FORCE)
endif()

project(
  untitled
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
include(CompilerOptions)
include(Sanitizers)

set(LIB_NAME ${PROJECT_NAME}_lib)
set(PROGRAM_NAME ${PROJECT_NAME})
set(TEST_PROGRAM_NAME ${PROJECT_NAME}_test)

add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")
include_directories(include)

find_package(GTest REQUIRED)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/lib/*.cpp)

add_library(${LIB_NAME} SHARED ${SOURCES})
add_executable(${PROGRAM_NAME} src/main.cpp)
target_link_libraries(${PROGRAM_NAME} ${LIB_NAME})

file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS src/test/*.cpp)

enable_testing()
add_executable(${TEST_PROGRAM_NAME} ${SOURCES} ${TEST_SOURCES})
target_link_libraries(${TEST_PROGRAM_NAME} ${GTEST_BOTH_LIBRARIES})
add_test(NAME ${TEST_PROGRAM_NAME} COMMAND ${TEST_PROGRAM_NAME})

file(GLOB_RECURSE CLANG_FORMAT_SOURCES CONFIGURE_DEPENDS src/*.cpp include/*.h)
file(GLOB_RECURSE CMAKE_FORMAT_SOURCES CONFIGURE_DEPENDS cmake/*.cmake
     CMakeLists.txt)

if((CMAKE_BUILD_TYPE MATCHES "Debug") OR (CMAKE_BUILD_TYPE MATCHES
                                          "RelWithDebInfo"))
  option(COVERAGE "Open code coverage tool" ON)
  include(Format)
  include(Coverage)
endif()

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)

add_custom_target(uninstall COMMAND rm
                                    ${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME})
