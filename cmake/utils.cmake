#
# Copyright (c) 2020-present, Trail of Bits, Inc.
# All rights reserved.
#
# This source code is licensed in accordance with the terms specified in
# the LICENSE file found in the root directory of this source tree.
#

function(generateSettingsTarget)
  add_library(cxx_target_settings INTERFACE)
  target_compile_options(cxx_target_settings INTERFACE
    -Wall
    -pedantic
    -Wconversion
    -Wunused
    -Wshadow
    -fvisibility=hidden
    -Werror
    -Wno-deprecated-declarations
    -fno-omit-frame-pointer
  )

  set_target_properties(cxx_target_settings PROPERTIES
    INTERFACE_POSITION_INDEPENDENT_CODE ON
  )

  if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    list(APPEND compile_option_list -O0)
    list(APPEND compile_definition_list DEBUG)

  else()
    list(APPEND compile_option_list -O2)
    list(APPEND compile_definition_list NDEBUG)
  endif()

  if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug" OR "${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    list(APPEND compile_option_list -g3)
  else()
    list(APPEND compile_option_list -g0)
  endif()

  target_compile_options(cxx_target_settings INTERFACE
    ${compile_option_list}
  )

  target_compile_definitions(cxx_target_settings INTERFACE
    ${compile_definition_list}
  )

  target_compile_features(cxx_target_settings INTERFACE cxx_std_14)

  if(SYSPROF_ENABLE_LIBCPP)
    target_compile_options(cxx_target_settings INTERFACE
      -stdlib=libc++
    )

    target_link_options(cxx_target_settings INTERFACE
      -stdlib=libc++
    )

    target_link_libraries(cxx_target_settings INTERFACE
      libc++abi.a
      rt
    )

    find_library(cppfs_path "c++fs")
    if(NOT "${cppfs_path}" STREQUAL "cppfs_path-NOTFOUND")
      target_link_libraries(cxx_target_settings INTERFACE
        "${cppfs_path}"
      )
    endif()
  endif()
endfunction()