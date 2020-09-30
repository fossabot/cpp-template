cmake_minimum_required(VERSION 3.12)
project(test-project)

set(CMAKE_CXX_STANDARD 20)

find_package(klib REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} klib::klib)
