//
// Created by biezhihua on 2019/1/18.
//

#ifndef SPLAYER_GLOBALPLAYERFIELD_H
#define SPLAYER_GLOBALPLAYERFIELD_H

#include <sys/types.h>
#include <jni.h>

class GlobalPlayerField {
public:
    pthread_mutex_t mutex;
    jclass clazz;
    JavaVM *jvm;
};

#endif //SPLAYER_GLOBALPLAYERFIELD_H
