if(NOT COVERAGE)
  if((CMAKE_BUILD_TYPE MATCHES "Debug") OR (CMAKE_BUILD_TYPE MATCHES
                                            "RelWithDebInfo"))
    set(COVERAGE ON)
  else()
    set(COVERAGE OFF)
  endif()
endif()

if(COVERAGE)
  message(STATUS "Building with lcov Code Coverage Tools")

  include(Utility)
  append("--coverage" CMAKE_CXX_FLAGS)

  find_program(LCOV_PATH NAMES lcov)
  find_program(GENHTML_PATH NAMES genhtml)

  if(LCOV_PATH AND GENHTML_PATH)
    add_custom_target(
      coverage
      COMMAND ${LCOV_PATH} --directory . --zerocounters
      COMMAND ${TEST_PROGRAM_NAME} ${COVERAGE_RUN_ARGS}
      COMMAND ${LCOV_PATH} --no-external -b ${CMAKE_SOURCE_DIR} --directory .
              --capture --output-file coverage.info
      COMMAND ${GENHTML_PATH} -o coverage coverage.info
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS ${TEST_PROGRAM_NAME})
  else()
    message(FATAL_ERROR "lcov or genhtml not found")
  endif()
endif()
