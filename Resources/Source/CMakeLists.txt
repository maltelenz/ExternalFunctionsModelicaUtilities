cmake_minimum_required(VERSION 3.5)
set(CMAKE_BUILD_TYPE Release)
project(functions)
add_library(functions SHARED functions.c)

if(APPLE)
    # Allow unresolved symbols at link time
    target_link_options(functions PRIVATE "-undefined" "dynamic_lookup")
endif()
