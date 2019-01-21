
#include <jni.h>
#include <assert.h>
#include <pthread.h>
#include <string>
#include "s_global_player.h"
#include "s_log.h"

extern "C" {
#include "libavutil/error.h"
#include "libavutil/log.h"
}

static s_global_player *g_player;

extern "C" JNIEXPORT jstring JNICALL Java_com_bzh_splayer_SPlayer_stringFromJNI(JNIEnv *env, jobject) {
    ALOGD("%s\n", __func__);
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

extern "C" JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *reserved) {
    ALOGD("%s\n", __func__);

    g_player = new s_global_player();

    if (!g_player) {
        return JNI_VERSION_1_4;
    }

    JNIEnv *env = NULL;

    g_player->set_jvm(vm);
    if (vm->GetEnv((void **) &env, JNI_VERSION_1_4) != JNI_OK) {
        return -1;
    }
    assert(env != NULL);

    pthread_mutex_init(&g_player->mutex, NULL);

    return JNI_VERSION_1_4;
}

extern "C" JNIEXPORT void JNI_OnUnload(JavaVM *jvm, void *reserved) {
    ALOGD("%s\n", __func__);

    if (!g_player) {
        return;
    }

    pthread_mutex_destroy(&g_player->mutex);

    delete g_player;

    g_player = NULL;
}

extern "C" JNIEXPORT void JNICALL Java_com_bzh_splayer_SPlayer_nativeCreate(JNIEnv *env, jobject instance) {
    ALOGD("%s\n", __func__);

    s_media_player *mp = g_player->create_media();
    if (!mp) {
        return;
    }
}

extern "C" JNIEXPORT void JNICALL Java_com_bzh_splayer_SPlayer_nativeDestroy(JNIEnv *env, jobject instance) {
    ALOGD("%s\n", __func__);
    if (!g_player) {
        return;
    }
    g_player->destroy_media();
}

extern "C" JNIEXPORT void JNICALL Java_com_bzh_splayer_SPlayer_nativeSetup(
        JNIEnv *env,
        jobject instance,
        jobject weak_this) {
    ALOGD("%s\n", __func__);
}
