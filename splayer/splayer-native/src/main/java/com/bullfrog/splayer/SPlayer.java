package com.bullfrog.splayer;

public class SPlayer {

    native String stringFromJNI();

    native void nativeInit();

    native void nativeSetup();

    static {
        System.loadLibrary("splayer")
        System.loadLibrary("sffmpeg")
    }

}
