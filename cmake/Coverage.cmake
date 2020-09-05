if(COVERAGE)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(STATUS "Building with LCOV code coverage tool")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")

    find_program(LCOV NAMES lcov)
    find_program(GENHTML NAMES genhtml)

    if(NOT LCOV)
      message(FATAL_ERROR "lcov not found")
    endif()

    if(NOT GENHTML)
      message(FATAL_ERROR "genhtml not found")
    endif()

    # --include '${CMAKE_SOURCE_DIR}/src/*'
    add_custom_target(
      coverage
      COMMAND ${LCOV} -d . -z
      COMMAND ${TEST_PROGRAM_NAME}
      COMMAND ${LCOV} -d . --include '${CMAKE_SOURCE_DIR}/src/*.cpp' --include
              '${CMAKE_SOURCE_DIR}/include/*.h' -c -o lcov.info
      COMMAND ${GENHTML} lcov.info -o coverage
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS ${TEST_PROGRAM_NAME})
  else()
    message(STATUS "Building with llvm-cov code coverage tool")
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -fprofile-instr-generate -fcoverage-mapping")

    find_program(LLVM_PROFDATA NAMES llvm-profdata)
    find_program(LLVM_COV NAMES llvm-cov)

    if(NOT LLVM_PROFDATA)
      message(FATAL_ERROR "llvm-profdata not found")
    endif()

    if(NOT LLVM_COV)
      message(FATAL_ERROR "llvm-cov not found")
    endif()

    add_custom_target(
      coverage
      COMMAND ${TEST_PROGRAM_NAME}
      COMMAND ${LLVM_PROFDATA} merge -sparse -o ${TEST_PROGRAM_NAME}.profdata
              default.profraw
      COMMAND
        ${LLVM_COV} show ${TEST_PROGRAM_NAME}
        -instr-profile=${TEST_PROGRAM_NAME}.profdata -format=html
        -output-dir=coverage
      COMMAND
        ${LLVM_COV} export ${TEST_PROGRAM_NAME}
        -instr-profile=${TEST_PROGRAM_NAME}.profdata -format=lcov > lcov.info
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      DEPENDS ${TEST_PROGRAM_NAME})
  endif()
endif()
