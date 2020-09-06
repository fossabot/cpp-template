if(FORMAT)
  find_program(CLANG_FORMAT_PATH NAMES clang-format)

  if(NOT CLANG_FORMAT_PATH)
    message(FATAL_ERROR "clang-format not found")
  endif()

  message(STATUS "clang-format found")
  add_custom_target(clang_format COMMAND ${CLANG_FORMAT_PATH} -i -verbose
                                         ${CLANG_FORMAT_SOURCES})
  add_dependencies(${LIB_NAME} clang_format)
  add_dependencies(${PROGRAM_NAME} clang_format)
  add_dependencies(${TEST_PROGRAM_NAME} clang_format)

  find_program(CMAKE_FORMAT_PATH NAMES cmake-format)

  if(NOT CMAKE_FORMAT_PATH)
    message(FATAL_ERROR "cmake-format not found")
  endif()

  message(STATUS "cmake-format found")
  add_custom_target(cmake_format COMMAND ${CMAKE_FORMAT_PATH} -i
                                         ${CMAKE_FORMAT_SOURCES})
  add_dependencies(${LIB_NAME} clang_format)
  add_dependencies(${PROGRAM_NAME} cmake_format)
  add_dependencies(${TEST_PROGRAM_NAME} cmake_format)
endif()
