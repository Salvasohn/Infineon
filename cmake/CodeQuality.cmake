set(PROJECT_QUALITY_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/runtime_stubs.c"
  "${CMAKE_CURRENT_SOURCE_DIR}/include/FreeRTOSConfig.h"
)

set(PROJECT_TIDY_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/runtime_stubs.c"
)

find_program(CLANG_FORMAT_EXECUTABLE NAMES clang-format clang-format-18)
if(CLANG_FORMAT_EXECUTABLE)
  add_custom_target(format
    COMMAND "${CLANG_FORMAT_EXECUTABLE}" -i ${PROJECT_QUALITY_SOURCES}
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT "Formatting first-party C/C++ sources with clang-format"
    VERBATIM
  )

  add_custom_target(format-check
    COMMAND "${CLANG_FORMAT_EXECUTABLE}" --dry-run --Werror ${PROJECT_QUALITY_SOURCES}
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT "Checking first-party C/C++ formatting"
    VERBATIM
  )
else()
  message(STATUS "clang-format not found; format and format-check targets are unavailable")
endif()

find_program(CLANG_TIDY_EXECUTABLE NAMES clang-tidy clang-tidy-18)
find_program(ARM_NONE_EABI_GXX_EXECUTABLE NAMES arm-none-eabi-g++)
if(CLANG_TIDY_EXECUTABLE AND ARM_NONE_EABI_GXX_EXECUTABLE)
  get_filename_component(ARM_GNU_BIN_DIR "${ARM_NONE_EABI_GXX_EXECUTABLE}" DIRECTORY)
  get_filename_component(ARM_GNU_TOOLCHAIN_ROOT "${ARM_GNU_BIN_DIR}" DIRECTORY)
  set(ARM_GNU_SYSROOT "${ARM_GNU_TOOLCHAIN_ROOT}/arm-none-eabi")

  add_custom_target(tidy
    COMMAND "${CLANG_TIDY_EXECUTABLE}"
      -p "${CMAKE_BINARY_DIR}"
      "--extra-arg-before=--target=arm-none-eabi"
      "--extra-arg-before=--gcc-toolchain=${ARM_GNU_TOOLCHAIN_ROOT}"
      "--extra-arg-before=--sysroot=${ARM_GNU_SYSROOT}"
      ${PROJECT_TIDY_SOURCES}
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMENT "Running clang-tidy against the ARM compile database"
    VERBATIM
  )
else()
  message(STATUS "clang-tidy or arm-none-eabi-g++ not found; tidy target is unavailable")
endif()
