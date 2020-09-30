if(BUILD_DOC)
  message(STATUS "Generating documentation")

  find_package(Doxygen REQUIRED)

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/doc/Doxyfile.in
                 ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)

  add_custom_target(
    doc
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT
      "Generating documentation ${CMAKE_CURRENT_SOURCE_DIR}/doc/html/index.html"
  )

  add_dependencies(${LIB_NAME} doc)
  add_dependencies(${PROGRAM_NAME} doc)
  if(BUILD_TESTING)
    add_dependencies(${TEST_PROGRAM_NAME} doc)
  endif()
endif()
