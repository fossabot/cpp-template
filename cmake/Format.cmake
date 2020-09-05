find_program(CLANG_FORMAT NAMES clang-format)

if(CLANG_FORMAT)
  message(STATUS "clang-format found")
  add_custom_target(clang_format COMMAND ${CLANG_FORMAT} -i -verbose
                                         ${CLANG_FORMAT_SOURCES})
  add_dependencies(${LIB_NAME} clang_format)
  add_dependencies(${PROGRAM_NAME} clang_format)
  add_dependencies(${TEST_PROGRAM_NAME} clang_format)
else()
  message(STATUS "clang-format not found")
endif()

find_program(CMAKE_FORMAT NAMES cmake-format)

if(CMAKE_FORMAT)
  message(STATUS "cmake-format found")
  add_custom_target(cmake_format COMMAND ${CMAKE_FORMAT} -i
                                         ${CMAKE_FORMAT_SOURCES})
  add_dependencies(${LIB_NAME} clang_format)
  add_dependencies(${PROGRAM_NAME} cmake_format)
  add_dependencies(${TEST_PROGRAM_NAME} cmake_format)
else()
  message(STATUS "cmake-format not found")
endif()
