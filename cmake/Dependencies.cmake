include(FetchContent)

# Pinned dependencies for reproducible builds.
FetchContent_Declare(
  xmclib
  GIT_REPOSITORY https://github.com/Infineon/mtb-xmclib-cat3.git
  GIT_TAG c24888699c6c5cfd6e5475be90d9703e43540d04
)
FetchContent_MakeAvailable(xmclib)

add_library(freertos_config INTERFACE)
target_include_directories(freertos_config SYSTEM INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${xmclib_SOURCE_DIR}/CMSIS/Core/Include
  ${xmclib_SOURCE_DIR}/CMSIS/Infineon/COMPONENT_XMC4500/Include
)
target_compile_definitions(freertos_config INTERFACE XMC4500_E144x1024)

set(FREERTOS_PORT GCC_ARM_CM4F CACHE STRING "" FORCE)
set(FREERTOS_HEAP 4 CACHE STRING "" FORCE)

FetchContent_Declare(
  freertos_kernel
  GIT_REPOSITORY https://github.com/FreeRTOS/FreeRTOS-Kernel.git
  GIT_TAG V11.2.0
  GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(freertos_kernel)
