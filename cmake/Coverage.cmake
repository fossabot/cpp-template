if(COVERAGE)
  include(AddCompilerFlag)

  if(CMAKE_COMPILER_IS_GNUCXX)
    message(STATUS "Building with coverage information, use lcov")

    add_required_compiler_flag("--coverage")

    get_filename_component(COMPILER_PATH "${CMAKE_CXX_COMPILER}" PATH)
    string(REGEX MATCH "^[0-9]+" GCC_VERSION "${CMAKE_CXX_COMPILER_VERSION}")
    find_program(
      GCOV_EXECUTABLE
      NAMES gcov-${GCC_VERSION} gcov
      HINTS ${COMPILER_PATH})

    find_program(LCOV_EXECUTABLE lcov)
    find_program(GENHTML_EXECUTABLE genhtml)

    if(NOT GCOV_EXECUTABLE)
      message(FATAL_ERROR "Can not find gcov")
    endif()

    if(NOT LCOV_EXECUTABLE)
      message(FATAL_ERROR "Can not find lcov")
    endif()

    if(NOT GENHTML_EXECUTABLE)
      message(FATAL_ERROR "Can not find genhtml")
    endif()

    add_custom_target(
      coverage
      COMMAND ${LCOV_EXECUTABLE} -d . -z
      COMMAND ${TEST_PROGRAM_NAME}
      COMMAND
        ${LCOV_EXECUTABLE} -d . --include
        '${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp' --include
        '${CMAKE_CURRENT_SOURCE_DIR}/include/*.h' --gcov-tool ${GCOV_EXECUTABLE}
        -c -o lcov.info --rc lcov_branch_coverage=1
      COMMAND ${GENHTML_EXECUTABLE} lcov.info -o coverage -s --title
              "${PROJECT_NAME}" --legend --demangle-cpp --branch-coverage
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS ${TEST_PROGRAM_NAME}
      COMMENT
        "Generating HTML report ${CMAKE_CURRENT_BINARY_DIR}/coverage/index.html"
    )
  else()
    message(STATUS "Building with coverage information, use llvm-cov")

    add_required_compiler_flag("-fprofile-instr-generate")
    add_required_compiler_flag("-fcoverage-mapping")

    find_program(LLVM_PROFDATA_EXECUTABLE llvm-profdata)
    find_program(LLVM_COV_EXECUTABLE llvm-cov)

    if(NOT LLVM_PROFDATA_EXECUTABLE)
      message(FATAL_ERROR "Can not find llvm-profdata")
    endif()

    if(NOT LLVM_COV_EXECUTABLE)
      message(FATAL_ERROR "Can not find llvm-cov")
    endif()

    add_custom_target(
      coverage
      COMMAND ${TEST_PROGRAM_NAME}
      COMMAND ${LLVM_PROFDATA_EXECUTABLE} merge -sparse -o
              ${TEST_PROGRAM_NAME}.profdata default.profraw
      COMMAND
        ${LLVM_COV_EXECUTABLE} show ${TEST_PROGRAM_NAME}
        -instr-profile=${TEST_PROGRAM_NAME}.profdata -format=html
        -output-dir=coverage -show-line-counts-or-regions
        -ignore-filename-regex=${CMAKE_CURRENT_SOURCE_DIR}/tests/*
      COMMAND
        ${LLVM_COV_EXECUTABLE} export ${TEST_PROGRAM_NAME}
        -instr-profile=${TEST_PROGRAM_NAME}.profdata
        -ignore-filename-regex=${CMAKE_CURRENT_SOURCE_DIR}/tests/* -format=lcov
        > lcov.info
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS ${TEST_PROGRAM_NAME}
      COMMENT
        "Generating HTML report ${CMAKE_CURRENT_BINARY_DIR}/coverage/index.html"
    )
  endif()
endif()
