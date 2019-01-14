//
// Splayer entrance file
//

#include <jni.h>
#include <android/log.h>

static const char *kTAG = "splayer_jni";

#define LOGI(...) \
  ((void)__android_log_print(ANDROID_LOG_INFO, kTAG, __VA_ARGS__))
#define LOGW(...) \
  ((void)__android_log_print(ANDROID_LOG_WARN, kTAG, __VA_ARGS__))
#define LOGE(...) \
  ((void)__android_log_print(ANDROID_LOG_ERROR, kTAG, __VA_ARGS__))

extern "C" JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *reserved) {
//    JNIEnv* env = NULL;
//
//    g_jvm = vm;
//    if ((*vm)->GetEnv(vm, (void**) &env, JNI_VERSION_1_4) != JNI_OK) {
//        return -1;
//    }
//    assert(env != NULL);
//
//    pthread_mutex_init(&g_clazz.mutex, NULL );
//
//    // FindClass returns LocalReference
//    IJK_FIND_JAVA_CLASS(env, g_clazz.clazz, JNI_CLASS_IJKPLAYER);
//    (*env)->RegisterNatives(env, g_clazz.clazz, g_methods, NELEM(g_methods) );
//
//    ijkmp_global_init();
//    ijkmp_global_set_inject_callback(inject_callback);
//
//    FFmpegApi_global_init(env);
    LOGE("JNI_OnLoad");

    return JNI_VERSION_1_4;
}

extern "C" JNIEXPORT void JNI_OnUnload(JavaVM *jvm, void *reserved) {
//    ijkmp_global_uninit();

//    pthread_mutex_destroy(&g_clazz.mutex);

    LOGE("JNI_OnUnload");
}