#ifndef SPLAYER_A_GLOBAL_EXCEPTION_H
#define SPLAYER_A_GLOBAL_EXCEPTION_H

#include <jni.h>
#include "s_log.h"

jint throwNoClassDefError(JNIEnv *env, char *message);

jint throwOutOfMemoryError(JNIEnv *env, char *message);

jint throwNoSuchFieldError(JNIEnv *env, char *message);

#endif //SPLAYER_A_GLOBAL_EXCEPTION_H
