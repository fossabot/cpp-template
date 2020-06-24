message(STATUS "Enable profile")

add_custom_target(
  profile
  COMMAND valgrind --tool=callgrind ./${PROGRAM_NAME} ${RUN_ARGS}
  COMMAND kcachegrind
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  DEPENDS ${PROGRAM_NAME})
