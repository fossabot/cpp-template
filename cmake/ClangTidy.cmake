if(CLANG_TIDY)
  message(STATUS "Use clang-tidy to analyze the code")

  find_program(CLANG_TIDY_PATH clang-tidy)

  if(NOT CLANG_TIDY_PATH)
    message(FATAL_ERROR "Can not find clang-tidy")
  endif()

  set(CMAKE_CXX_CLANG_TIDY clang-tidy --export-fixes=clang-tidy.txt)
endif()
