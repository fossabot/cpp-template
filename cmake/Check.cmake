if(NOT
   (CMAKE_SYSTEM_NAME STREQUAL "Linux"
    OR CMAKE_SYSTEM_NAME STREQUAL "Darwin"
    OR CMAKE_SYSTEM_NAME STREQUAL "Windows"))
  message(FATAL_ERROR "Only supports Linux system, macOS and Windows")
endif()

if(NOT
   (CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
    OR CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?[Cc]lang"
    OR CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"))
  message(FATAL_ERROR "Only supports GCC, Clang and MSVC")
endif()

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "In-source builds not allowed")
endif()

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type to 'Release' as none was specified")
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Choose Release or Debug" FORCE)
endif()
