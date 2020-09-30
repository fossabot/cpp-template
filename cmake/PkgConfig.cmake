set(pkgconfig_install_dir "${CMAKE_INSTALL_LIBDIR}/pkgconfig")
set(pkg_config "${CMAKE_BINARY_DIR}/klib.pc")

get_target_property(PKG_CONFIG_DEFINES klib INTERFACE_COMPILE_DEFINITIONS)
string(REPLACE ";" " -D" PKG_CONFIG_DEFINES "${PKG_CONFIG_DEFINES}")
string(CONCAT PKG_CONFIG_DEFINES "-D" "${PKG_CONFIG_DEFINES}")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/klib.pc.in" "${pkg_config}"
               @ONLY)
install(FILES "${pkg_config}" DESTINATION "${pkgconfig_install_dir}")
