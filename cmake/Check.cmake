if(NOT ((CMAKE_SYSTEM_NAME STREQUAL "Linux"
    AND (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES
                                                 "[Cc]lang"))
   OR (CMAKE_SYSTEM_NAME STREQUAL "Darwin" AND CMAKE_CXX_COMPILER_ID MATCHES
                                               "(Apple)?[Cc]lang")
   OR (CMAKE_SYSTEM_NAME STREQUAL "Windows" AND CMAKE_CXX_COMPILER_ID STREQUAL
                                                "MSVC")))

  message(FATAL_ERROR "The system and compiler combination does not support")
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
