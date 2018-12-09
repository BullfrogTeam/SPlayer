#include <jni.h>
#include <string>

extern "C" {

#include "libavutil/error.h"
#include "libavutil/log.h"

JNIEXPORT jstring JNICALL
Java_com_bullfrog_splayer_MainActivity_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    char errbuf[128];
    const char *errbuf_ptr = errbuf;
    av_log(NULL, AV_LOG_ERROR, "%s: %s\n", "biezihua", errbuf_ptr);
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}
}