# === Target: test program ===

find_package(GTest REQUIRED)

add_executable(${TEST_PROGRAM_NAME} ${TEST_SOURCES})
target_link_libraries(${TEST_PROGRAM_NAME} PRIVATE ${LIB_NAME}
                                                   ${GTEST_LIBRARIES})
gtest_discover_tests(${TEST_PROGRAM_NAME})

# ===============
# === Options ===
# ===============

option(SANITIZER "Build test suite with Clang sanitizer" OFF)
option(VALGRIND "Execute test suite with Valgrind" OFF)
option(COVERAGE "Build test suite with coverage information" OFF)

if(SANITIZER)
  message(STATUS "Building test suite with Clang sanitizer")
  set(CMAKE_CXX_FLAGS
      "-g -O0 -fsanitize=address -fsanitize=undefined -fsanitize=integer -fsanitize=nullability -fno-omit-frame-pointer -fno-sanitize-recover=all -fsanitize-recover=unsigned-integer-overflow"
  )
endif()

if(VALGRIND)
  find_program(CMAKE_MEMORYCHECK_COMMAND valgrind)
  message(
    STATUS "Executing test suite with Valgrind (${CMAKE_MEMORYCHECK_COMMAND})")
  set(memcheck_command
      "${CMAKE_MEMORYCHECK_COMMAND} --error-exitcode=1 --leak-check=full")
  separate_arguments(memcheck_command)
endif()

if(COVERAGE)
  message(STATUS "Building test suite with coverage information")

  get_filename_component(COMPILER_PATH "${CMAKE_CXX_COMPILER}" PATH)
  string(REGEX MATCH "^[0-9]+" GCC_VERSION "${CMAKE_CXX_COMPILER_VERSION}")
  find_program(
    GCOV_BIN
    NAMES gcov-${GCC_VERSION} gcov
    HINTS ${COMPILER_PATH})

  file(GLOB_RECURSE SOURCE_FILES ${NLOHMANN_JSON_INCLUDE_BUILD_DIR}*.hpp)

  add_custom_target(
    lcov_html
    COMMAND lcov --directory . --capture --output-file json.info --rc
            lcov_branch_coverage=1
    COMMAND lcov -e json.info ${SOURCE_FILES} --output-file json.info.filtered
            --gcov-tool ${GCOV_BIN} --rc lcov_branch_coverage=1
    COMMAND ${CMAKE_SOURCE_DIR}/test/thirdparty/imapdl/filterbr.py
            json.info.filtered > json.info.filtered.noexcept
    COMMAND
      genhtml --title "JSON for Modern C++" --legend --demangle-cpp
      --output-directory html --show-details --branch-coverage
      json.info.filtered.noexcept
    COMMENT "Generating HTML report test/html/index.html")
endif()

if(COVERAGE)
  target_compile_options(${TEST_PROGRAM_NAME} PRIVATE --coverage)
  target_link_libraries(${TEST_PROGRAM_NAME} PRIVATE --coverage)
endif()

if(VALGRIND)
  add_test(
    NAME "${TEST_PROGRAM_NAME}_valgrind"
    COMMAND ${memcheck_command} ${CMAKE_CURRENT_BINARY_DIR}/${TEST_PROGRAM_NAME}
            ${DOCTEST_TEST_FILTER}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
  set_tests_properties("${TEST_PROGRAM_NAME}_valgrind" PROPERTIES LABELS
                                                                  "valgrind")
endif()
