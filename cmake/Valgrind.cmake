if(VALGRIND)
  message(STATUS "Executing test suite with Valgrind")

  find_program(VALGRIND_EXECUTABLE valgrind)

  if(NOT VALGRIND_EXECUTABLE)
    message(FATAL_ERROR "Can not find valgrind")
  endif()

  add_test(
    NAME "${TEST_PROGRAM_NAME}-valgrind"
    COMMAND
      ${VALGRIND_EXECUTABLE} --error-exitcode=1 --track-origins=yes
      --gen-suppressions=all --leak-check=full
      ${CMAKE_CURRENT_BINARY_DIR}/${TEST_PROGRAM_NAME})
endif()
