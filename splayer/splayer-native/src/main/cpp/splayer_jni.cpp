//
// Splayer entrance file
//

#include <jni.h>
#include <android/log.h>
#include <assert.h>
#include <pthread.h>
#include "GlobalPlayerField.h"

static const char *kTAG = "splayer_jni";

#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, kTAG, __VA_ARGS__))
#define LOGW(...) ((void)__android_log_print(ANDROID_LOG_WARN, kTAG, __VA_ARGS__))
#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, kTAG, __VA_ARGS__))

static GlobalPlayerField *global_player_field = new GlobalPlayerField();

extern "C" JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *reserved) {
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

    pthread_mutex_destroy(&global_player_field->mutex);

    LOGE("JNI_OnUnload");
}