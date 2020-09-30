if(BUILD_DOC)
  find_package(Doxygen REQUIRED)

  file(GLOB SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../include/*)
  file(GLOB MARKDOWN_DOC ${CMAKE_CURRENT_SOURCE_DIR}/../doc/*.md)
  list(APPEND MARKDOWN_DOC ${CMAKE_CURRENT_SOURCE_DIR}/../readme.md)

  configure_file(Doxyfile.in Doxyfile @ONLY)
  configure_file(Doxyfile.zh-cn.in Doxyfile.zh-cn @ONLY)

  file(GLOB DOXYFILES ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile*)

  add_custom_command(
    OUTPUT html
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.zh-cn
    COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_BINARY_DIR}/html
    DEPENDS ${MARKDOWN_DOC} ${SOURCES} ${DOXYFILES}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../)

  add_custom_target(doc ALL DEPENDS html)
  install(
    DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
    DESTINATION ${DOC_INSTALL_DIR}
    COMPONENT doc)
endif()
