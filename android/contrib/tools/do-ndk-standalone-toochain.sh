#! /usr/bin/env bash

# https://developer.android.com/ndk/guides/standalone_toolchain?hl=zh-cn

FF_ARCH=$1
FF_BUILD_ROOT=`pwd`

echo ""
echo "--------------------"
echo "[*] make NDK standalone toolchain"

FF_BUILD_NAME=
FF_ANDROID_PLATFORM=
FF_TOOLCHAIN_NAME=

#----- armv7a begin -----
if [ "$FF_ARCH" = "armv7a" ]; then
    
    FF_BUILD_NAME=ffmpeg-armv7a
    FF_ANDROID_PLATFORM=android-21
    FF_CROSS_PREFIX=arm-linux-androideabi
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}

elif [ "$FF_ARCH" = "armv5" ]; then
  
    FF_ANDROID_PLATFORM=android-21
    FF_BUILD_NAME=ffmpeg-armv5
    FF_CROSS_PREFIX=arm-linux-androideabi
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}
    
elif [ "$FF_ARCH" = "x86" ]; then

    FF_ANDROID_PLATFORM=android-21
    FF_BUILD_NAME=ffmpeg-x86
    FF_CROSS_PREFIX=i686-linux-android
    FF_TOOLCHAIN_NAME=x86-${FF_GCC_VER}
    

elif [ "$FF_ARCH" = "x86_64" ]; then

    FF_ANDROID_PLATFORM=android-21
    FF_BUILD_NAME=ffmpeg-x86_64
    FF_CROSS_PREFIX=x86_64-linux-android
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_64_VER}

elif [ "$FF_ARCH" = "arm64" ]; then
    
    FF_ANDROID_PLATFORM=android-21
    FF_BUILD_NAME=ffmpeg-arm64
    FF_CROSS_PREFIX=aarch64-linux-android
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_64_VER}

else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi

FF_MAKE_TOOLCHAIN_FLAGS=$MAKE_TOOLCHAIN_FLAGS
FF_MAKE_FLAGS=$MAKE_FLAG
FF_GCC_VER=$GCC_VER
FF_GCC_64_VER=$GCC_64_VER
FF_TOOLCHAIN_PATH=$FF_BUILD_ROOT/build/$FF_BUILD_NAME/toolchain
FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --install-dir=$FF_TOOLCHAIN_PATH"
FF_TOOLCHAIN_TOUCH="$FF_TOOLCHAIN_PATH/touch"

echo "FF_ARCH = $FF_ARCH"

echo ""

echo "FF_BUILD_ROOT = $FF_BUILD_ROOT"

echo ""

echo "FF_MAKE_FLAGS = $FF_MAKE_FLAGS"
echo "FF_GCC_VER = $FF_GCC_VER"
echo "FF_GCC_64_VER = $FF_GCC_64_VER"

echo ""
echo "FF_TOOLCHAIN_PATH = $FF_TOOLCHAIN_PATH"
echo "FF_MAKE_TOOLCHAIN_FLAGS = $FF_MAKE_TOOLCHAIN_FLAGS"
echo "FF_TOOLCHAIN_TOUCH = $FF_TOOLCHAIN_TOUCH"
echo "FF_ANDROID_PLATFORM = $FF_ANDROID_PLATFORM"
echo "FF_BUILD_NAME = $FF_BUILD_NAME"
echo "FF_TOOLCHAIN_NAME = $FF_TOOLCHAIN_NAME"
echo "--------------------"

if [ ! -f "$FF_TOOLCHAIN_TOUCH" ]; then
    
    $ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
        $FF_MAKE_TOOLCHAIN_FLAGS \
        --platform=$FF_ANDROID_PLATFORM \
        --toolchain=$FF_TOOLCHAIN_NAME
        
    touch $FF_TOOLCHAIN_TOUCH;
fi