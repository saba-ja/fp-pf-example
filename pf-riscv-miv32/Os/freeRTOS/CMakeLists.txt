# Add source files
register_fprime_module(Os_Task_freeRTOS)
add_library(Os_freeRTOS_Task STATIC Task.cpp)
choose_fprime_implementation(Os_Task_freeRTOS)
