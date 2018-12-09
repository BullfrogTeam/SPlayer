# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html
cmake_minimum_required(VERSION 3.4.1)

get_filename_component(SPLAYER_ANDROID ${CMAKE_CURRENT_SOURCE_DIR}/../../../../.. ABSOLUTE)

get_filename_component(SPLAYER_FF_OUTPUT ${SPLAYER_ANDROID}/contrib/build/ffmpeg-armv7a/output ABSOLUTE)

get_filename_component(SPLAYER_FF_OUTPUT_INCLUDE ${SPLAYER_FF_OUTPUT}/include ABSOLUTE)

get_filename_component(SPLAYER_FF_OUTPUT_SO ${SPLAYER_FF_OUTPUT}/libsffmpeg.so ABSOLUTE)

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
        log)
