package com.bzh.splayer;

import java.lang.ref.WeakReference;

public class SPlayer {

    public native String stringFromJNI();

    public native void nativeCreate();

    public native void nativeSetup(WeakReference<SPlayer> weakReference);

    public native void nativeDestroy();

    static {
        System.loadLibrary("splayer");
        System.loadLibrary("sffmpeg");
    }

}
