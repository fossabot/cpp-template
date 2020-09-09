if(CLANG_TIDY)
  find_program(CLANG_TIDY_PATH clang-tidy)

  if(NOT CLANG_TIDY_PATH)
    message(FATAL_ERROR "Can not find clang-tidy")
  endif()

  message(STATUS "Found clang-tidy")
  set(CMAKE_CXX_CLANG_TIDY clang-tidy -header-filter=.*)
endif()
