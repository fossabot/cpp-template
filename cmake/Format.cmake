if(FORMAT)
  message(STATUS "Format code using clang-foramt and cmake-foramt")

  find_program(CLANG_FORMAT_PATH clang-format)
  find_program(CMAKE_FORMAT_PATH cmake-format)

  if(NOT CLANG_FORMAT_PATH)
    message(FATAL_ERROR "Can not find clang-format")
  endif()

  if(NOT CMAKE_FORMAT_PATH)
    message(FATAL_ERROR "Can not find cmake-format")
  endif()

  file(GLOB_RECURSE CLANG_FORMAT_SOURCES CONFIGURE_DEPENDS
       ${CMAKE_SOURCE_DIR}/include/*.h ${CMAKE_SOURCE_DIR}/src/*.cpp
       ${CMAKE_SOURCE_DIR}/tests/*.cpp)
  file(GLOB_RECURSE CMAKE_FORMAT_SOURCES CONFIGURE_DEPENDS
       ${CMAKE_SOURCE_DIR}/cmake/*.cmake ${CMAKE_SOURCE_DIR}/CMakeLists.txt)

  add_custom_target(
    format
    COMMAND ${CLANG_FORMAT_PATH} -i ${CLANG_FORMAT_SOURCES}
    COMMAND ${CMAKE_FORMAT_PATH} -i ${CMAKE_FORMAT_SOURCES}
    COMMENT "Format C++ and CMake files")

  set(project_directories "")
  get_property(
    stack
    DIRECTORY ${CMAKE_SOURCE_DIR}
    PROPERTY SUBDIRECTORIES)
  while(stack)
    list(POP_BACK stack directory)
    list(APPEND project_directories ${directory})
    get_property(
      subdirs
      DIRECTORY ${directory}
      PROPERTY SUBDIRECTORIES)
    if(subdirs)
      list(APPEND stack ${subdirs})
    endif()
  endwhile()

  function(get_targets found_targets)
    foreach(dir ${project_directories})
      get_property(
        target
        DIRECTORY ${dir}
        PROPERTY BUILDSYSTEM_TARGETS)
      list(APPEND targets ${target})
    endforeach()
    set(${found_targets}
        ${targets}
        PARENT_SCOPE)
  endfunction()

  get_targets(targets)

  foreach(target ${targets})
    add_dependencies(${target} format)
  endforeach()
endif()
