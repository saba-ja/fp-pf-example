####
# F prime CMakeLists.txt:
#
# SOURCE_FILES: combined list of source and autocoding files
# MOD_DEPS: (optional) module dependencies
#
####

# If FreeRTOS scheduler is set, remove the previous task-related files and add in the FreeRTOS variant
if (FPRIME_USE_FREERTOS_SCHEDULER)
    message(STATUS "Using FreeRTOS")
    # Should path to Baremetal directory in your project
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/../../fprime/Os/Baremetal/File.cpp") 
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/../../fprime/Os/Baremetal/FileSystem.cpp")
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/../../fprime/Os/Baremetal/IntervalTimer.cpp")
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/../../fprime/Os/Baremetal/SystemResources.cpp")
    # Should path to freeRTOS directory
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/freeRTOS/InterruptLock.cpp")
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/freeRTOS/Mutex.cpp")
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/freeRTOS/Queue.cpp")
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/freeRTOS/Task.cpp")
    list(APPEND SOURCE_FILES "${CMAKE_CURRENT_LIST_DIR}/freeRTOS/TaskId.cpp")
    list(APPEND MOD_DEPS "freertos")
endif()

register_fprime_module()

# Add stubs directory for testing builds
if (BUILD_TESTING)
    add_fprime_subdirectory("${CMAKE_CURRENT_LIST_DIR}/../../fprime/Os/Stubs/") # Should path to Stubs directory
endif()
