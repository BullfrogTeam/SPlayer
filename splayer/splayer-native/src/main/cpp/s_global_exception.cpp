#include "s_global_exception.h"

jint throwException(JNIEnv *env, const char *className, const char *msg) {
    if (env->ExceptionCheck()) {
        jthrowable exception = env->ExceptionOccurred();
        env->ExceptionClear();

        if (exception != NULL) {
            ALOGW("Discarding pending exception (%s) to throw", className);
            env->DeleteLocalRef(exception);
        }
    }

    jclass exceptionClass = env->FindClass(className);
    if (exceptionClass == NULL) {
        ALOGE("Unable to find exception class %s", className);
        /* ClassNotFoundException now pending */
        return -1;
    }

    if (env->ThrowNew(exceptionClass, msg) != JNI_OK) {
        ALOGE("Failed throwing '%s' '%s'", className, msg);
        /* an exception, most likely OOM, will now be pending */
        env->DeleteLocalRef(exceptionClass);
        return -1;
    }
    return 0;
}

jint throwNoClassDefError(JNIEnv *env, char *message) {
    return throwException(env, "java/lang/NoClassDefFoundError", message);
}

jint throwOutOfMemoryError(JNIEnv *env, char *message) {
    return throwException(env, "java/lang/OutOfMemoryError", message);
}

jint throwNoSuchFieldError(JNIEnv *env, char *message) {
    return throwException(env, "java/lang/NoSuchFieldError", message);
}