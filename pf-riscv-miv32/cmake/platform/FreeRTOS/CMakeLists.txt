add_library(freertos
    ${CMAKE_CURRENT_LIST_DIR}/croutine.c
    ${CMAKE_CURRENT_LIST_DIR}/event_groups.c
    ${CMAKE_CURRENT_LIST_DIR}/list.c
    ${CMAKE_CURRENT_LIST_DIR}/queue.c
    ${CMAKE_CURRENT_LIST_DIR}/string.c
    ${CMAKE_CURRENT_LIST_DIR}/tasks.c
    ${CMAKE_CURRENT_LIST_DIR}/timers.c
    ${CMAKE_CURRENT_LIST_DIR}/portable/GCC/RISCV/port.c
    ${CMAKE_CURRENT_LIST_DIR}/portable/GCC/RISCV/portasm.S
    ${CMAKE_CURRENT_LIST_DIR}/portable/MemMang/heap_1.c
    ${CMAKE_CURRENT_LIST_DIR}/portable/MemMang/heap_2.c
    ${CMAKE_CURRENT_LIST_DIR}/portable/MemMang/heap_3.c
    ${CMAKE_CURRENT_LIST_DIR}/portable/MemMang/heap_4.c
    ${CMAKE_CURRENT_LIST_DIR}/portable/MemMang/heap_5.c
)

# Specify the language for the .S file explicitly if needed
# set_source_files_properties(${CMAKE_CURRENT_LIST_DIR}/portable/GCC/RISCV/portasm.S PROPERTIES LANGUAGE C ASM)
