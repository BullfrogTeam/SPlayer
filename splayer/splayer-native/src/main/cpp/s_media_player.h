

#ifndef SPLAYER_S_MEDIA_PLAYER_H
#define SPLAYER_S_MEDIA_PLAYER_H


#include <sys/types.h>

class s_media_player {
private:
    volatile int ref_count;

    pthread_mutex_t mutex;

    int (*msg_loop)(void *);

    int mp_state;

    char *data_source;
    void *weak_thiz;

    int restart;
    int restart_from_beginning;
    int seek_req;
    long seek_msec;

public:

};


#endif //SPLAYER_S_MEDIA_PLAYER_H
