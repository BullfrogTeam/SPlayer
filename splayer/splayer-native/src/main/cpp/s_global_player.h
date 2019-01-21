#ifndef SPLAYER_GLOBALPLAYERFIELD_H
#define SPLAYER_GLOBALPLAYERFIELD_H

#include <sys/types.h>
#include <jni.h>
#include "s_media_player.h"

class s_global_player {
private:
    jclass clazz;
    JavaVM *jvm;
    s_media_player *media_player;

public:
    pthread_mutex_t mutex;

    void set_jvm(JavaVM *javaVM);

    void set_clazz(jclass clazz);

    s_media_player *create_media();

    void destroy_media();
};


#endif //SPLAYER_GLOBALPLAYERFIELD_H
