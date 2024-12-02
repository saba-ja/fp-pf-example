# Specify the OS type include directive
add_definitions(-DTGT_OS_TYPE_FREERTOS)

# Specify that a thread package should be searched in the toolchain directory
if (NOT DEFINED FPRIME_USE_FREERTOS_SCHEDULER)
    set(FPRIME_USE_FREERTOS_SCHEDULER ON)
    # message(STATUS "Requiring thread library")
    # FIND_PACKAGE ( Threads REQUIRED )
endif()

# Define SKIP_FLOAT_IEEE_754_COMPLIANCE
add_definitions(-DSKIP_FLOAT_IEEE_754_COMPLIANCE=1)

# Text Logging OFF
add_definitions(-DFW_ENABLE_TEXT_LOGGING=0)
set(FPRIME_ENABLE_TEXT_LOGGERS OFF)

# Specify a directory containing the "PlatformTypes.hpp" headers, as well as other system headers
set(FREERTOS_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/FreeRTOS/include")
if(NOT EXISTS "${FREERTOS_INCLUDE_DIR}")
    message(FATAL_ERROR "FreeRTOS include directory not found at ${FREERTOS_INCLUDE_DIR}.")
endif()

choose_fprime_implementation(Os/File Os/File/Stub)

include_directories(SYSTEM "${FREERTOS_INCLUDE_DIR}")


# Build FreeRTOS source
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}/../../Os/freeRTOS")
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}/FreeRTOS/portable/GCC/RISCV")
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}/FreeRTOS/portable/MemMang")
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}/hal")
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}/riscv_hal")
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}")

# Add any additional platform-specific settings or libraries as needed
link_directories(${CMAKE_CURRENT_LIST_DIR}/FreeRTOS/lib)


# Add PlatformTypes.h
include_directories(SYSTEM "${CMAKE_CURRENT_LIST_DIR}/types")
add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/FreeRTOS")
