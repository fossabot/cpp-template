cmake_minimum_required(VERSION 3.12)
project(test-project LANGUAGES C CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ../cmake)

include(Check)
include(CompilerOptions)
include(LTO)

find_package(klib REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE klib::klib)
