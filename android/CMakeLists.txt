cmake_minimum_required(VERSION 3.10.2)
project(device_info_kit LANGUAGES CXX)

add_library(device_info_kit SHARED
    src/main/cpp/device_info_bridge.cpp
)

target_link_libraries(device_info_kit
    log
)
