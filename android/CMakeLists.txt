cmake_minimum_required(VERSION 3.22.1)
project("device_info_kit" C CXX)

add_library(device_info_kit SHARED
    src/main/cpp/device_info_bridge.cpp
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_library(log-lib log)
find_library(android-lib android)


target_link_libraries(device_info_kit
    ${log-lib}
    ${android-lib}
)
