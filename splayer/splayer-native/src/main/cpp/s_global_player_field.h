#ifndef SPLAYER_GLOBALPLAYERFIELD_H
#define SPLAYER_GLOBALPLAYERFIELD_H

#include <sys/types.h>
#include <jni.h>

class s_global_player_field {
public:
    pthread_mutex_t mutex;
    jclass clazz;
    JavaVM *jvm;
};

#endif //SPLAYER_GLOBALPLAYERFIELD_H
