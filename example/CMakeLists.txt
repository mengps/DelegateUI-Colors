cmake_minimum_required(VERSION 3.16)

project(DelegateUI-Colors-Example VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_add_executable(${PROJECT_NAME})
qt_add_qml_module(${PROJECT_NAME}
    URI example
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        Example.qml
    SOURCES
        main.cpp
)

target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../src)

target_link_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../buildlib)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt::Quick DelegateUI-Colors)
