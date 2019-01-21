
#include <jni.h>
#include <assert.h>
#include <pthread.h>
#include <string>
#include "s_global_player_field.h"
#include "s_log.h"

extern "C" {
#include "libavutil/error.h"
#include "libavutil/log.h"
}

static s_global_player_field *global_player_field = new s_global_player_field();

extern "C" JNIEXPORT jstring JNICALL Java_com_bzh_splayer_SPlayer_stringFromJNI(JNIEnv *env, jobject) {
    ALOGD("%s\n", __func__);
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

extern "C" JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *reserved) {
    ALOGD("%s\n", __func__);

    JNIEnv *env = NULL;

    global_player_field->jvm = vm;
    if (vm->GetEnv((void **) &env, JNI_VERSION_1_4) != JNI_OK) {
        return -1;
    }
    assert(env != NULL);

    pthread_mutex_init(&global_player_field->mutex, NULL);

    return JNI_VERSION_1_4;
}

extern "C" JNIEXPORT void JNI_OnUnload(JavaVM *jvm, void *reserved) {
    ALOGD("%s\n", __func__);
    pthread_mutex_destroy(&global_player_field->mutex);
}

extern "C" JNIEXPORT void JNICALL Java_com_bzh_splayer_SPlayer_nativeInit(JNIEnv *env, jobject instance) {
    ALOGD("%s\n", __func__);
}

extern "C" JNIEXPORT void JNICALL Java_com_bzh_splayer_SPlayer_nativeSetup(JNIEnv *env, jobject instance) {
    ALOGD("%s\n", __func__);
}