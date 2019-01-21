package com.bzh.splayer;

public class SPlayer {

    public native String stringFromJNI();

    public native void nativeInit();

    public native void nativeSetup();

    static {
        System.loadLibrary("splayer");
        System.loadLibrary("sffmpeg");
    }

}
