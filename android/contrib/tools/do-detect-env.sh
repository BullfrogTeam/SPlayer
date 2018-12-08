#! /usr/bin/env bash

set -e

UNAME_S=$(uname -s)
UNAME_SM=$(uname -sm)

echo "build on $UNAME_SM"
echo "ANDROID_NDK=$ANDROID_NDK"

if [ -z "$ANDROID_NDK" ]; then
    echo "You must define ANDROID_NDK before starting."
    echo "They must point to your NDK directories."
    echo ""
    exit 1
fi

# try to detect NDK version
export GCC_VER=4.9
export GCC_64_VER=4.9
export MAKE_TOOLCHAIN_FLAGS=
export MAKE_FLAG=
export NDK_REL=$(grep -o '^Pkg\.Revision.*=[0-9]*.*' $ANDROID_NDK/source.properties 2>/dev/null | sed 's/[[:space:]]*//g' | cut -d "=" -f 2)

case "$NDK_REL" in
    11*|12*|13*|14*|16*)
        if test -d ${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9
        then
            echo "NDKr$NDK_REL detected"
        else
            echo "You need the NDKr10e or later"
            exit 1
        fi
    ;;
    *)
        echo "You need the NDKr10e or later"
        exit 1
    ;;
esac

case "$UNAME_S" in
    Darwin)
        export MAKE_FLAG=-j`sysctl -n machdep.cpu.thread_count`
    ;;
esac
