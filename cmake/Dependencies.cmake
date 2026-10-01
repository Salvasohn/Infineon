# Local third-party dependencies. The gitlinks in ThirdParty/ pin the exact
# revisions; CMake must not fetch alternative versions implicitly.
set(THIRDPARTY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ThirdParty")
set(xmclib_SOURCE_DIR "${THIRDPARTY_DIR}/XMCLib")
set(freertos_kernel_SOURCE_DIR "${THIRDPARTY_DIR}/FreeRTOS-Kernel")
set(segger_rtt_SOURCE_DIR "${THIRDPARTY_DIR}/SEGGER_RTT")
set(cmsis_core_SOURCE_DIR "${THIRDPARTY_DIR}/CMSIS_5")

if(NOT EXISTS "${xmclib_SOURCE_DIR}/CMSIS/Infineon/COMPONENT_XMC4500/Include/XMC4500.h"
   OR NOT EXISTS "${freertos_kernel_SOURCE_DIR}/CMakeLists.txt"
   OR NOT EXISTS "${segger_rtt_SOURCE_DIR}/RTT/SEGGER_RTT.c"
   OR NOT EXISTS "${cmsis_core_SOURCE_DIR}/CMSIS/Core/Include/core_cm4.h")
  message(FATAL_ERROR
    "ThirdParty submodules are not initialized. Run: git submodule update --init --recursive")
endif()

add_library(freertos_config INTERFACE)
target_include_directories(freertos_config SYSTEM INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${cmsis_core_SOURCE_DIR}/CMSIS/Core/Include
  ${xmclib_SOURCE_DIR}/CMSIS/Infineon/COMPONENT_XMC4500/Include
)
target_compile_definitions(freertos_config INTERFACE XMC4500_E144x1024)

set(FREERTOS_PORT GCC_ARM_CM4F CACHE STRING "" FORCE)
set(FREERTOS_HEAP 4 CACHE STRING "" FORCE)
add_subdirectory(
  "${freertos_kernel_SOURCE_DIR}"
  "${CMAKE_BINARY_DIR}/ThirdParty/FreeRTOS-Kernel"
  EXCLUDE_FROM_ALL
)

add_library(segger_rtt_port STATIC
  ${segger_rtt_SOURCE_DIR}/RTT/SEGGER_RTT.c
  ${segger_rtt_SOURCE_DIR}/RTT/SEGGER_RTT_printf.c
)
target_include_directories(segger_rtt_port PUBLIC
  ${segger_rtt_SOURCE_DIR}/RTT
  ${segger_rtt_SOURCE_DIR}/Config
)
