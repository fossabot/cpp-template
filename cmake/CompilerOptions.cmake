include(Utility)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_options(-Wall -Wextra -Wpedantic -Werror)

if(CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?[Cc]lang")
  add_link_options(-fuse-ld=lld)

  if((CMAKE_BUILD_TYPE STREQUAL "Debug") OR (CMAKE_BUILD_TYPE STREQUAL
                                             "RelWithDebInfo"))
    append("-fstandalone-debug" CMAKE_CXX_FLAGS)
  endif()
endif()

if((CMAKE_BUILD_TYPE STREQUAL "Release") OR (CMAKE_BUILD_TYPE STREQUAL
                                             "RelWithDebInfo"))
  append("-flto" CMAKE_CXX_FLAGS)
endif()