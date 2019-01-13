#include <jni.h>
#include <string>

// 911c615f-b484-4b7b-86f2-de397fe58090
// 85d10159-0c61-4ffb-839b-dcd3ddf21069

extern "C" {
//#include "libavutil/error.h"
//#include "libavutil/log.h"
}

extern "C" JNIEXPORT jstring JNICALL Java_com_bullfrog_splayer_MainActivity_stringFromJNI(JNIEnv *env, jobject) {
    char errbuf[128];
    const char *errbuf_ptr = errbuf;
//    av_log(NULL, AV_LOG_ERROR, "%s: %s\n", "biezihua", errbuf_ptr);
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}