# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html
cmake_minimum_required(VERSION 3.4.1)

get_filename_component(SPLAYER_ANDROID ${CMAKE_CURRENT_SOURCE_DIR}/../../../../.. ABSOLUTE)

#

if (${ANDROID_ABI} STREQUAL "armeabi-v7a")
    get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/contrib/build/ffmpeg-armv7a/output ABSOLUTE)
elseif (${ANDROID_ABI} STREQUAL "arm64-v8a")
    get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/contrib/build/ffmpeg-armv8a/output ABSOLUTE)
elseif (${ANDROID_ABI} STREQUAL "x86")
    get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/contrib/build/ffmpeg-x86/output ABSOLUTE)
else ()
    message("Not Support ${ANDROID_ABI}")
endif ()

get_filename_component(SPLAYER_FF_OUTPUT_INCLUDE ${SPLAYER_FF_OUTPUT}/include ABSOLUTE)

get_filename_component(SPLAYER_FF_OUTPUT_SO ${SPLAYER_FF_OUTPUT}/libsffmpeg.so ABSOLUTE)

if (${ANDROID_ABI} STREQUAL "armeabi-v7a")
    file(COPY ${SPLAYER_FF_OUTPUT_SO} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../libs/armeabi-v7a/)
elseif (${ANDROID_ABI} STREQUAL "arm64-v8a")
    file(COPY ${SPLAYER_FF_OUTPUT_SO} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../libs/arm64-v8a/)
elseif (${ANDROID_ABI} STREQUAL "x86")
    file(COPY ${SPLAYER_FF_OUTPUT_SO} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../libs/x86/)
else ()
    message("Not Support ${ANDROID_ABI}")
endif ()

add_library(sffmpeg
        SHARED
        IMPORTED
        )

set_target_properties(sffmpeg
        PROPERTIES IMPORTED_LOCATION
        ${SPLAYER_FF_OUTPUT_SO}
        )

include_directories(${SPLAYER_FF_OUTPUT_INCLUDE})

add_library(splayer
        SHARED
        native-lib.cpp)

target_link_libraries(splayer
        sffmpeg
        log
        z)
