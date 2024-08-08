cmake_minimum_required(VERSION 3.25)
project(lab_5_Smirnov LANGUAGES CXX ASM)

set(CMAKE_CXX_STANDARD 23)

# Path to FASM compiler
set(FASM_EXECUTABLE_PATH "D:\\soft\\FASM\\FASM.EXE")

add_custom_command(
        OUTPUT find_reversed_substring.obj
        COMMAND ${FASM_EXECUTABLE_PATH} ${CMAKE_SOURCE_DIR}/find_reversed_substring.asm find_reversed_substring.obj
        DEPENDS find_reversed_substring.asm
)

add_executable(lab_5_Smirnov main.cpp find_reversed_substring.obj)

