if(FORMAT)
  message(STATUS "Formating code using clang-foramt and cmake-foramt")

  find_program(CLANG_FORMAT_EXECUTABLE clang-format)
  find_program(CMAKE_FORMAT_EXECUTABLE cmake-format)

  if(NOT CLANG_FORMAT_EXECUTABLE)
    message(FATAL_ERROR "Can not find clang-format")
  endif()

  if(NOT CMAKE_FORMAT_EXECUTABLE)
    message(FATAL_ERROR "Can not find cmake-format")
  endif()

  file(
    GLOB_RECURSE
    CLANG_FORMAT_SOURCES
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/benchmark/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/test_project/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp)

  file(
    GLOB_RECURSE
    CMAKE_FORMAT_SOURCES
    CONFIGURE_DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/*.cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/test_project/*.cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt)

  add_custom_target(
    format
    COMMAND ${CLANG_FORMAT_EXECUTABLE} -i ${CLANG_FORMAT_SOURCES}
    COMMAND ${CMAKE_FORMAT_EXECUTABLE} -i ${CMAKE_FORMAT_SOURCES}
    COMMENT "Format C++ and CMake files")
endif()
