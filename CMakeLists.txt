cmake_minimum_required(VERSION 3.24)

project(xmc4500_freertos_rtt LANGUAGES C CXX ASM)

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" FW_VERSION)
string(STRIP "${FW_VERSION}" FW_VERSION)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(cmake/Dependencies.cmake)

set(XMC4500_DEVICE_DIR "${xmclib_SOURCE_DIR}/CMSIS/Infineon/COMPONENT_XMC4500")
set(XMC4500_LINKER_SCRIPT "${XMC4500_DEVICE_DIR}/Source/TOOLCHAIN_GCC_ARM/XMC4500x1024.ld")

add_library(xmc4500_platform OBJECT
  ${XMC4500_DEVICE_DIR}/Source/system_XMC4500.c
  ${XMC4500_DEVICE_DIR}/Source/TOOLCHAIN_GCC_ARM/startup_XMC4500.S
)
target_include_directories(xmc4500_platform PUBLIC
  ${cmsis_core_SOURCE_DIR}/CMSIS/Core/Include
  ${XMC4500_DEVICE_DIR}/Include
  ${xmclib_SOURCE_DIR}/XMCLib/inc
)
target_compile_definitions(xmc4500_platform PUBLIC XMC4500_E144x1024)

add_executable(${PROJECT_NAME}
  src/main.cpp
  src/runtime_stubs.c
)
set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".elf")
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
target_compile_definitions(${PROJECT_NAME} PRIVATE
  XMC4500_E144x1024
  FW_VERSION=\"${FW_VERSION}\"
)
target_compile_options(${PROJECT_NAME} PRIVATE
  -Wall
  -Wextra
  -Wpedantic
  $<$<CONFIG:Debug>:-Og;-g3>
  $<$<CONFIG:Release>:-O2>
)
target_link_libraries(${PROJECT_NAME} PRIVATE
  xmc4500_platform
  freertos_kernel
  segger_rtt_port
)
target_link_options(${PROJECT_NAME} PRIVATE
  -nostartfiles
  --specs=nano.specs
  -T${XMC4500_LINKER_SCRIPT}
  -Wl,--gc-sections
  -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.map
  -Wl,--print-memory-usage
)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
  COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PROJECT_NAME}> ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.hex
  COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}> ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin
  COMMENT "Generating HEX/BIN images"
)

include(cmake/CodeQuality.cmake)

message(STATUS "Firmware version: ${FW_VERSION}")
message(STATUS "Target: Infineon XMC4500E144x1024")
