#ifndef SPLAYER_S_LOG_H
#define SPLAYER_S_LOG_H

#include <stdio.h>

//
#ifdef  __ANDROID__

#include <android/log.h>

#define S_LOG_UNKNOWN     ANDROID_LOG_UNKNOWN
#define S_LOG_DEFAULT     ANDROID_LOG_DEFAULT

#define S_LOG_VERBOSE     ANDROID_LOG_VERBOSE
#define S_LOG_DEBUG       ANDROID_LOG_DEBUG
#define S_LOG_INFO        ANDROID_LOG_INFO
#define S_LOG_WARN        ANDROID_LOG_WARN
#define S_LOG_ERROR       ANDROID_LOG_ERROR
#define S_LOG_FATAL       ANDROID_LOG_FATAL
#define S_LOG_SILENT      ANDROID_LOG_SILENT

// https://developer.android.com/ndk/reference/group/logging
#define VLOG(level, TAG, ...)    ((void)__android_log_vprint(level, TAG, __VA_ARGS__))
#define ALOG(level, TAG, ...)    ((void)__android_log_print(level, TAG, __VA_ARGS__))

#else

#define S_LOG_UNKNOWN     0
#define S_LOG_DEFAULT     1

#define S_LOG_VERBOSE     2
#define S_LOG_DEBUG       3
#define S_LOG_INFO        4
#define S_LOG_WARN        5
#define S_LOG_ERROR       6
#define S_LOG_FATAL       7
#define S_LOG_SILENT      8

#define VLOG(level, TAG, ...)    ((void)vprintf(__VA_ARGS__))
#define ALOG(level, TAG, ...)    ((void)printf(__VA_ARGS__))

#endif
//

#define S_LOG_TAG "S_MEDIA"

#define VLOGV(...)  VLOG(S_LOG_VERBOSE,   S_LOG_TAG, __VA_ARGS__)
#define VLOGD(...)  VLOG(S_LOG_DEBUG,     S_LOG_TAG, __VA_ARGS__)
#define VLOGI(...)  VLOG(S_LOG_INFO,      S_LOG_TAG, __VA_ARGS__)
#define VLOGW(...)  VLOG(S_LOG_WARN,      S_LOG_TAG, __VA_ARGS__)
#define VLOGE(...)  VLOG(S_LOG_ERROR,     S_LOG_TAG, __VA_ARGS__)

#define ALOGV(...)  ALOG(S_LOG_VERBOSE,   S_LOG_TAG, __VA_ARGS__)
#define ALOGD(...)  ALOG(S_LOG_DEBUG,     S_LOG_TAG, __VA_ARGS__)
#define ALOGI(...)  ALOG(S_LOG_INFO,      S_LOG_TAG, __VA_ARGS__)
#define ALOGW(...)  ALOG(S_LOG_WARN,      S_LOG_TAG, __VA_ARGS__)
#define ALOGE(...)  ALOG(S_LOG_ERROR,     S_LOG_TAG, __VA_ARGS__)

#endif //SPLAYER_S_LOG_H
