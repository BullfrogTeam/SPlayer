package com.bullfrog.splayer

class SPlayer {

    external fun stringFromJNI(): String

    companion object {

        // Used to load the 'native-lib' library on application startup.
        init {
            System.loadLibrary("splayer")
        }
    }
}