#------------------------------------------------------------------------------
# Description : RISC-V toolchain cmake file to populate required build tools
#
# Author      : 
# Initial Date: 11/28/2024
#
# Change log:
#
#------------------------------------------------------------------------------

# Look for GCC in path
FIND_FILE(RISCV_COMPILER_PATH "riscv64-unknown-elf-gcc" PATHS ENV INCLUDE)

if (EXISTS ${RISCV_COMPILER_PATH})
    set(RISCV_GCC_COMPILER "${RISCV_COMPILER_PATH}")
else()
    # Stop early if RISC-V GCC was not found
    message(FATAL_ERROR "RISC-V GCC not found.")
endif()

message(STATUS "RISC-V GCC found: ${RISCV_GCC_COMPILER}")

get_filename_component(RISCV_TOOLCHAIN_BIN_PATH "${RISCV_GCC_COMPILER}" DIRECTORY)
get_filename_component(RISCV_TOOLCHAIN_BIN_GCC "${RISCV_GCC_COMPILER}" NAME_WE)
get_filename_component(RISCV_TOOLCHAIN_BIN_EXT "${RISCV_GCC_COMPILER}" EXT)

# Extract the GCC file prefix to be used for other required tools
STRING(REGEX REPLACE "-gcc" "" CROSS_COMPILER_PREFIX "${RISCV_TOOLCHAIN_BIN_GCC}")

message(STATUS "RISC-V RISCV_TOOLCHAIN_BIN_PATH: ${RISCV_TOOLCHAIN_BIN_PATH}")
message(STATUS "RISC-V CROSS_COMPILER_PREFIX:    ${CROSS_COMPILER_PREFIX}")

set(CMAKE_C_COMPILER   "${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILER_PREFIX}-gcc")
set(CMAKE_CXX_COMPILER "${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILER_PREFIX}-g++")
set(CMAKE_ASM_COMPILER "${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILER_PREFIX}-gcc")
set(CMAKE_AR           "${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILER_PREFIX}-ar")
set(CMAKE_OBJCOPY      "${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILER_PREFIX}-objcopy"
    CACHE FILEPATH "The toolchain objcopy command" FORCE)
set(CMAKE_OBJDUMP      "${RISCV_TOOLCHAIN_BIN_PATH}/${CROSS_COMPILER_PREFIX}-objdump"
    CACHE FILEPATH "The toolchain objdump command" FORCE)

set(COMPILER_LIST
    ${CMAKE_C_COMPILER}
    ${CMAKE_CXX_COMPILER}
    ${CMAKE_ASM_COMPILER}
    ${CMAKE_AR}
    ${CMAKE_OBJCOPY}
    ${CMAKE_OBJDUMP}     
)

set(COMPILER_NAMES
    "C Compiler"
    "C++ Compiler"
    "ASM Compiler"
    "AR Tool"
    "Objcopy Tool"
    "Objdump Tool"
)

# Check if all required tools exist
foreach(comp_addr comp_name IN ZIP_LISTS COMPILER_LIST COMPILER_NAMES)
    if(NOT EXISTS "${comp_addr}")
        message(FATAL_ERROR "Could not find ${comp_name} in provided address '${comp_addr}'")
    endif()
endforeach()

message(STATUS "RISC-V CMAKE_C_COMPILER:   ${CMAKE_C_COMPILER}")
message(STATUS "RISC-V CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
message(STATUS "RISC-V CMAKE_ASM_COMPILER: ${CMAKE_ASM_COMPILER}")
message(STATUS "RISC-V CMAKE_AR:           ${CMAKE_AR}")
message(STATUS "RISC-V CMAKE_OBJCOPY:      ${CMAKE_OBJCOPY}")
message(STATUS "RISC-V CMAKE_OBJDUMP:      ${CMAKE_OBJDUMP}")

set(CMAKE_SYSTEM_NAME       "riscv-mivrv32i")
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
# RV32I is a load-store ISA with 32, 32-bit general-purpose integer registers.
set(CMAKE_SYSTEM_PROCESSOR  "rv32i")

message(STATUS "RISC-V CMAKE_SYSTEM_NAME:       ${CMAKE_SYSTEM_NAME}")
message(STATUS "RISC-V CMAKE_EXECUTABLE_SUFFIX: ${CMAKE_EXECUTABLE_SUFFIX}")
message(STATUS "RISC-V CMAKE_SYSTEM_PROCESSOR:  ${CMAKE_SYSTEM_PROCESSOR}")


# Architecture and ABI
# FIXEME the rv32imaf depends on the MiV configuration in the Firmware. Care must be taken to match this value with the setup in the Firmware
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=rv32imaf -mabi=ilp32f -mcmodel=medany -msmall-data-limit=8 -mstrict-align -mno-save-restore")

# Debugging and Optimization
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g3")

# Code generation
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsigned-char -ffunction-sections -fdata-sections -fmessage-length=0")

# Linker script and options
set(LINKER_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/miv-rv32-ram.ld")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${LINKER_SCRIPT} -nostartfiles -Xlinker --gc-sections -Wl,-Map,miv-rv32imaf-cpp.map --specs=nano.specs --specs=nosys.specs")

# Prevent CMake from adding its own -mcpu and -mthumb flags which conflict with the specific flags required for the ATSAME70Q21B processor
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS_INIT}" CACHE STRING "Initial C FLAGS" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS_INIT}" CACHE STRING "Initial CXX FLAGS" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS_INIT}" CACHE STRING "Initial EXE LINKER FLAGS" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# FPrime specifics
set(FPRIME_PLATFORM "RiscvFreeRTOS")
# Remove POSIX
set(FPRIME_USE_POSIX OFF)
