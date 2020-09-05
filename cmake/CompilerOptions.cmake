set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

string(APPEND CMAKE_CXX_FLAGS " -Wall -Wextra -Wpedantic -Werror")

if(CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?[Cc]lang")
  if(NOT (CMAKE_SYSTEM_NAME STREQUAL "Darwin"))
    add_link_options(-fuse-ld=lld)
  endif()

  if((CMAKE_BUILD_TYPE STREQUAL "Debug") OR (CMAKE_BUILD_TYPE STREQUAL
                                             "RelWithDebInfo"))
    string(APPEND CMAKE_CXX_FLAGS " -fstandalone-debug")
  endif()
else()
  # FIXME
  if(NOT CLANG_TIDY)
    string(APPEND CMAKE_CXX_FLAGS " -fanalyzer")
  endif()
endif()

if((CMAKE_BUILD_TYPE STREQUAL "Release") OR (CMAKE_BUILD_TYPE STREQUAL
                                             "RelWithDebInfo"))
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()
