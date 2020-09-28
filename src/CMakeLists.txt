file(GLOB_RECURSE LIB_SOURCES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/src/*.cpp)
set(SOURCES ${CMAKE_SOURCE_DIR}/src/main.cpp)
list(REMOVE_ITEM LIB_SOURCES ${SOURCES})

add_definitions(-DAPP_VERSION="${PROJECT_VERSION}")
add_library(${LIB_NAME} OBJECT ${LIB_SOURCES})
target_include_directories(${LIB_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)

add_executable(${PROGRAM_NAME} ${SOURCES})
target_link_libraries(${PROGRAM_NAME} PRIVATE ${LIB_NAME})
