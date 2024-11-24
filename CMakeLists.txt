cmake_minimum_required(VERSION 3.29)
project(A2)

set(CMAKE_CXX_STANDARD 20)

add_executable(A2 main.cpp
        ArrayGenerator.cpp
        ArrayGenerator.h
        SortAlgorithms.cpp
        SortAlgorithms.h)
