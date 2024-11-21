cmake_minimum_required(VERSION 3.16)

project(DelegateUI-Colors VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Gui)

qt_add_library(${PROJECT_NAME} STATIC
    delcolorgenerate.h
    delcolorgenerate.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../buildlib
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt::Gui)
