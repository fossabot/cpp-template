if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL
                                              "Darwin"))
  message(FATAL_ERROR "Only support Linux system and macOS")
endif()

if(NOT (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES
                                                "(Apple)?[Cc]lang"))
  message(FATAL_ERROR "Only supports GCC and Clang")
endif()
