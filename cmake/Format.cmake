if(FORMAT)
  find_program(CLANG_FORMAT_PATH clang-format)

  if(NOT CLANG_FORMAT_PATH)
    message(FATAL_ERROR "Can not find clang-format")
  endif()

  message(STATUS "Found clang-format")
  add_custom_target(clang_format COMMAND ${CLANG_FORMAT_PATH} -i -verbose
                                         ${CLANG_FORMAT_SOURCES})
  add_dependencies(${LIB_NAME} clang_format)
  add_dependencies(${PROGRAM_NAME} clang_format)
  add_dependencies(${TEST_PROGRAM_NAME} clang_format)

  find_program(CMAKE_FORMAT_PATH cmake-format)

  if(NOT CMAKE_FORMAT_PATH)
    message(FATAL_ERROR "Can not find cmake-format")
  endif()

  message(STATUS "Found cmake-format")
  add_custom_target(cmake_format COMMAND ${CMAKE_FORMAT_PATH} -i
                                         ${CMAKE_FORMAT_SOURCES})
  add_dependencies(${LIB_NAME} clang_format)
  add_dependencies(${PROGRAM_NAME} cmake_format)
  add_dependencies(${TEST_PROGRAM_NAME} cmake_format)
endif()
