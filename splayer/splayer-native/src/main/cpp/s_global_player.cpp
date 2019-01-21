#include "s_global_player.h"

void s_global_player::set_clazz(jclass clazz) {
    s_global_player::clazz = clazz;
}

void s_global_player::set_jvm(JavaVM *javaVM) {
    s_global_player::jvm = javaVM;
}

s_media_player *s_global_player::create_media() {
    media_player = new s_media_player();
    return media_player;
}

void s_global_player::destroy_media() {
    delete media_player;
    media_player = NULL;
}
