if(VALGRIND)
  find_program(VALGRIND_PATH valgrind)
  message(STATUS "Executing test suite with Valgrind")

  add_test(NAME "${TEST_PROGRAM_NAME}-valgrind"
           COMMAND ${VALGRIND_PATH} --error-exitcode=1 --leak-check=full
                   ${CMAKE_CURRENT_BINARY_DIR}/${TEST_PROGRAM_NAME})
endif()
