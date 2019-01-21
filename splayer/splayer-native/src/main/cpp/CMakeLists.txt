# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html
cmake_minimum_required(VERSION 3.4.1)

get_filename_component(SPLAYER_ANDROID ${CMAKE_CURRENT_SOURCE_DIR}/../../../.. ABSOLUTE)

if (${ANDROID_ABI} STREQUAL "armeabi-v7a")
    get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/splayer-ffmpeg-output/ffmpeg-armv7a ABSOLUTE)
elseif (${ANDROID_ABI} STREQUAL "arm64-v8a")
    get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/splayer-ffmpeg-output/ffmpeg-armv8a ABSOLUTE)
elseif (${ANDROID_ABI} STREQUAL "x86")
    get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/splayer-ffmpeg-output/ffmpeg-x86 ABSOLUTE)
else ()
    message("Not Support ${ANDROID_ABI}")
endif ()

get_filename_component(SPLAYER_FF_OUTPUT_INCLUDE ${SPLAYER_FF_OUTPUT}/include/ ABSOLUTE)

get_filename_component(SPLAYER_FF_OUTPUT_SO ${SPLAYER_FF_OUTPUT}/lib/libsffmpeg.so ABSOLUTE)

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
        splayer_jni.cpp
        )

target_link_libraries(splayer
        sffmpeg
        log
        z)
