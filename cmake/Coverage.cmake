if(COVERAGE)
  include(Utility)

  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(STATUS "Building with lcov Code Coverage Tools")
    append("--coverage" CMAKE_CXX_FLAGS)

    find_program(GCOV_PATH NAMES gcov)
    find_program(LCOV_PATH NAMES lcov)
    find_program(GENHTML_PATH NAMES genhtml)

    if(GCOV_PATH
       AND LCOV_PATH
       AND GENHTML_PATH)
      add_custom_target(
        coverage
        COMMAND ${LCOV_PATH} --no-external --gcov-tool ${GCOV_PATH} -directory .
                -b ${CMAKE_SOURCE_DIR} --zerocounters
        COMMAND ${LCOV_PATH} --no-external --gcov-tool ${GCOV_PATH} -c -i -d .
                -b ${CMAKE_SOURCE_DIR} -o coverage.base
        COMMAND ${TEST_PROGRAM_NAME} ${COVERAGE_RUN_ARGS}
        COMMAND
          ${LCOV_PATH} --no-external --gcov-tool ${GCOV_PATH} --directory . -b
          ${CMAKE_SOURCE_DIR} --capture --output-file coverage.capture
        COMMAND ${LCOV_PATH} --no-external --gcov-tool ${GCOV_PATH} -a
                coverage.base -a coverage.capture --output-file coverage.total
        COMMAND ${LCOV_PATH} --no-external --gcov-tool ${GCOV_PATH} --remove
                coverage.total --output-file coverage.info
        COMMAND ${GENHTML_PATH} -o coverage coverage.info
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        DEPENDS ${TEST_PROGRAM_NAME})
    else()
      message(FATAL_ERROR "gcov or lcov not found")
    endif()
  else()
    message(STATUS "Building with llvm Code Coverage Tools")
    append("-fprofile-instr-generate -fcoverage-mapping" CMAKE_CXX_FLAGS)

    find_program(LLVM_PROFDATA_PATH NAMES llvm-profdata)
    find_program(LLVM_COV_PATH NAMES llvm-cov)

    if(LLVM_PROFDATA_PATH AND LLVM_COV_PATH)
      add_custom_target(
        coverage
        COMMAND ${TEST_PROGRAM_NAME} ${COVERAGE_RUN_ARGS}
        COMMAND ${LLVM_PROFDATA_PATH} merge -sparse -o
                ${TEST_PROGRAM_NAME}.profdata default.profraw
        COMMAND
          ${LLVM_COV_PATH} show ${TEST_PROGRAM_NAME}
          -instr-profile=${TEST_PROGRAM_NAME}.profdata
          -show-line-counts-or-regions -format=html -output-dir=coverage
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        DEPENDS ${TEST_PROGRAM_NAME})
    else()
      message(FATAL_ERROR "llvm-profdata or llvm-cov not found")
    endif()
  endif()
endif()
