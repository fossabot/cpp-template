if(SANITIZER)
  if(NOT (SANITIZER STREQUAL "Thread"))
    string(APPEND CMAKE_CXX_FLAGS " -fno-omit-frame-pointer")
  endif()

  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    string(APPEND CMAKE_CXX_FLAGS " -O1")
  endif()

  macro(try_append_clang_undefined_sanitizer_flags)
    if(CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?Clang")
      string(
        APPEND
        CMAKE_CXX_FLAGS
        " -fsanitize=float-divide-by-zero,unsigned-integer-overflow,implicit-conversion,local-bounds,nullability -fsanitize-recover=unsigned-integer-overflow"
      )
    endif()
  endmacro()

  if(SANITIZER STREQUAL "Address")
    message(STATUS "Building with AddressSanitizer")
    string(APPEND CMAKE_CXX_FLAGS " -fsanitize=address")
  elseif(SANITIZER STREQUAL "Thread")
    message(STATUS "Building with ThreadSanitizer")
    string(APPEND CMAKE_CXX_FLAGS " -fsanitize=thread")
  elseif(SANITIZER STREQUAL "Memory")
    if(CMAKE_COMPILER_IS_GNUCXX)
      message(FATAL_ERROR "GCC does not support MemorySanitizer")
    endif()

    message(STATUS "Building with MemorySanitizer")
    string(APPEND CMAKE_CXX_FLAGS
           " -fsanitize=memory -fsanitize-memory-track-origins -fPIE")
  elseif(SANITIZER STREQUAL "Undefined")
    message(STATUS "Building with UndefinedSanitizer")

    string(APPEND CMAKE_CXX_FLAGS
           " -fsanitize=undefined -fno-sanitize-recover=all")
    try_append_clang_undefined_sanitizer_flags()
  elseif(SANITIZER STREQUAL "Address;Undefined")
    message(STATUS "Building with AddressSanitizer and UndefinedSanitizer")

    string(APPEND CMAKE_CXX_FLAGS
           " -fsanitize=address,undefined -fno-sanitize-recover=all")
    try_append_clang_undefined_sanitizer_flags()
  else()
    message(FATAL_ERROR "The Sanitizer is not supported: ${SANITIZER}")
  endif()
endif()
