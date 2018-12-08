#! /usr/bin/env bash

echo "===================="
echo "[*] check env ing $1"
echo "===================="
set -e

# common defines
FF_ARCH=$1
FF_BUILD_OPT=$2

echo "FF_ARCH=$FF_ARCH"
echo "FF_BUILD_OPT=$FF_BUILD_OPT"

# -z 字符串	字符串的长度为零则为真
if [ -z "$FF_ARCH" ]; then
    echo "You must specific an architecture 'arm, armv7a, x86, ...'."
    exit 1
fi

FF_BUILD_ROOT=`pwd`
FF_ANDROID_PLATFORM=android-21

FF_BUILD_NAME=
FF_SOURCE=
FF_CROSS_PREFIX=
FF_DEP_OPENSSL_INC=
FF_DEP_OPENSSL_LIB=

FF_DEP_LIBSOXR_INC=
FF_DEP_LIBSOXR_LIB=

FF_CFG_FLAGS=

FF_EXTRA_CFLAGS=
FF_EXTRA_LDFLAGS=
FF_DEP_LIBS=

FF_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
FF_ASSEMBLER_SUB_DIRS=

echo ""
echo "--------------------"
echo "[*] make NDK env"
. ./tools/do-detect-env.sh
echo "--------------------"

#--------------------
echo ""
echo "--------------------"
echo "[*] make params"

FF_MAKE_FLAGS=$MAKE_FLAG
FF_GCC_VER=$GCC_VER
FF_GCC_64_VER=$GCC_64_VER

if [ "$FF_ARCH" = "armv7a" ]; then
    FF_BUILD_NAME=ffmpeg-armv7a
    FF_BUILD_NAME_OPENSSL=openssl-armv7a
    FF_BUILD_NAME_LIBSOXR=libsoxr-armv7a
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=arm-linux-androideabi
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=arm --cpu=cortex-a8"
    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-neon"
    FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-thumb"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"
    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS -Wl,--fix-cortex-a8"

    FF_ASSEMBLER_SUB_DIRS="arm"

elif [ "$FF_ARCH" = "armv5" ]; then
    FF_BUILD_NAME=ffmpeg-armv5
    FF_BUILD_NAME_OPENSSL=openssl-armv5
    FF_BUILD_NAME_LIBSOXR=libsoxr-armv5
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=arm-linux-androideabi
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=arm"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -march=armv5te -mtune=arm9tdmi -msoft-float"
    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS"

    FF_ASSEMBLER_SUB_DIRS="arm"

elif [ "$FF_ARCH" = "x86" ]; then
    FF_BUILD_NAME=ffmpeg-x86
    FF_BUILD_NAME_OPENSSL=openssl-x86
    FF_BUILD_NAME_LIBSOXR=libsoxr-x86
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=i686-linux-android
    FF_TOOLCHAIN_NAME=x86-${FF_GCC_VER}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=x86 --cpu=i686 --enable-yasm"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS -march=atom -msse3 -ffast-math -mfpmath=sse"
    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS"

    FF_ASSEMBLER_SUB_DIRS="x86"

elif [ "$FF_ARCH" = "x86_64" ]; then
    FF_ANDROID_PLATFORM=android-21

    FF_BUILD_NAME=ffmpeg-x86_64
    FF_BUILD_NAME_OPENSSL=openssl-x86_64
    FF_BUILD_NAME_LIBSOXR=libsoxr-x86_64
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=x86_64-linux-android
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_64_VER}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=x86_64 --enable-yasm"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS"
    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS"

    FF_ASSEMBLER_SUB_DIRS="x86"

elif [ "$FF_ARCH" = "arm64" ]; then
    FF_ANDROID_PLATFORM=android-21

    FF_BUILD_NAME=ffmpeg-arm64
    FF_BUILD_NAME_OPENSSL=openssl-arm64
    FF_BUILD_NAME_LIBSOXR=libsoxr-arm64
    FF_SOURCE=$FF_BUILD_ROOT/$FF_BUILD_NAME

    FF_CROSS_PREFIX=aarch64-linux-android
    FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_64_VER}

    FF_CFG_FLAGS="$FF_CFG_FLAGS --arch=aarch64 --enable-yasm"

    FF_EXTRA_CFLAGS="$FF_EXTRA_CFLAGS"
    FF_EXTRA_LDFLAGS="$FF_EXTRA_LDFLAGS"

    FF_ASSEMBLER_SUB_DIRS="aarch64 neon"

else
    echo "unknown architecture $FF_ARCH";
    exit 1
fi

if [ ! -d $FF_SOURCE ]; then
    echo ""
    echo "!! ERROR"
    echo "!! Can not find FFmpeg directory for $FF_BUILD_NAME"
    echo "!! Run 'sh init-android.sh' first"
    echo ""
    exit 1
fi

FF_PREFIX=$FF_BUILD_ROOT/build/$FF_BUILD_NAME/output
FF_TOOLCHAIN_PATH=$FF_BUILD_ROOT/build/$FF_BUILD_NAME/toolchain

FF_SYSROOT=$FF_TOOLCHAIN_PATH/sysroot

FF_DEP_OPENSSL_INC=$FF_BUILD_ROOT/build/$FF_BUILD_NAME_OPENSSL/output/include
FF_DEP_OPENSSL_LIB=$FF_BUILD_ROOT/build/$FF_BUILD_NAME_OPENSSL/output/lib
FF_DEP_LIBSOXR_INC=$FF_BUILD_ROOT/build/$FF_BUILD_NAME_LIBSOXR/output/include
FF_DEP_LIBSOXR_LIB=$FF_BUILD_ROOT/build/$FF_BUILD_NAME_LIBSOXR/output/lib

mkdir -p $FF_PREFIX

echo "param FF_MAKE_FLAGS = $FF_MAKE_FLAGS"
echo "param FF_GCC_VER = $FF_GCC_VER"
echo "param FF_GCC_64_VER = $FF_GCC_64_VER"
echo ""
echo "param FF_BUILD_NAME = $FF_BUILD_NAME"
echo "param FF_BUILD_NAME_OPENSSL = $FF_BUILD_NAME_OPENSSL"
echo "param FF_BUILD_NAME_LIBSOXR = $FF_BUILD_NAME_LIBSOXR"
echo "param FF_SOURCE = $FF_SOURCE"
echo "param FF_CROSS_PREFIX = $FF_CROSS_PREFIX"
echo "param FF_TOOLCHAIN_NAME = $FF_TOOLCHAIN_NAME"
echo ""
echo "param FF_CFG_FLAGS = $FF_CFG_FLAGS"
echo "param FF_EXTRA_CFLAGS = $FF_EXTRA_CFLAGS"
echo "param FF_EXTRA_LDFLAGS = $FF_EXTRA_LDFLAGS"
echo "param FF_ASSEMBLER_SUB_DIRS = $FF_ASSEMBLER_SUB_DIRS"
echo ""
echo "param FF_PREFIX = $FF_PREFIX"
echo "param FF_TOOLCHAIN_PATH = $FF_TOOLCHAIN_PATH"
echo "param FF_SYSROOT = $FF_SYSROOT"
echo "param FF_DEP_OPENSSL_INC = $FF_DEP_OPENSSL_INC"
echo "param FF_DEP_OPENSSL_LIB = $FF_DEP_OPENSSL_LIB"
echo "param FF_DEP_LIBSOXR_INC = $FF_DEP_LIBSOXR_INC"
echo "param FF_DEP_LIBSOXR_LIB = $FF_DEP_LIBSOXR_LIB"
echo "--------------------"

# make ndk standalone toolchain
./tools/do-ndk-standalone-toochain.sh $FF_ARCH

# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] check ffmpeg env"
# echo "--------------------"

# export PATH=$FF_TOOLCHAIN_PATH/bin:$PATH
# #export CC="ccache ${FF_CROSS_PREFIX}-gcc"
# export CC="${FF_CROSS_PREFIX}-gcc"
# export LD=${FF_CROSS_PREFIX}-ld
# export AR=${FF_CROSS_PREFIX}-ar
# export STRIP=${FF_CROSS_PREFIX}-strip

# echo $FF_TOOLCHAIN_PATH
# echo $CC

# FF_CFLAGS="-O3 -Wall -pipe \
#     -std=c99 \
#     -ffast-math \
#     -fstrict-aliasing -Werror=strict-aliasing \
#     -Wno-psabi -Wa,--noexecstack \
#     -DANDROID -DNDEBUG"

# # cause av_strlcpy crash with gcc4.7, gcc4.8
# # -fmodulo-sched -fmodulo-sched-allow-regmoves

# # --enable-thumb is OK
# #FF_CFLAGS="$FF_CFLAGS -mthumb"

# # not necessary
# #FF_CFLAGS="$FF_CFLAGS -finline-limit=300"

# export COMMON_FF_CFG_FLAGS=
# . $FF_BUILD_ROOT/../../config/module.sh


# #--------------------
# # with openssl
# if [ -f "${FF_DEP_OPENSSL_LIB}/libssl.a" ]; then
#     echo "OpenSSL detected"
# # FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-nonfree"
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-openssl"

#     FF_CFLAGS="$FF_CFLAGS -I${FF_DEP_OPENSSL_INC}"
#     FF_DEP_LIBS="$FF_DEP_LIBS -L${FF_DEP_OPENSSL_LIB} -lssl -lcrypto"
# fi

# if [ -f "${FF_DEP_LIBSOXR_LIB}/libsoxr.a" ]; then
#     echo "libsoxr detected"
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-libsoxr"

#     FF_CFLAGS="$FF_CFLAGS -I${FF_DEP_LIBSOXR_INC}"
#     FF_DEP_LIBS="$FF_DEP_LIBS -L${FF_DEP_LIBSOXR_LIB} -lsoxr"
# fi

# FF_CFG_FLAGS="$FF_CFG_FLAGS $COMMON_FF_CFG_FLAGS"

# #--------------------
# # Standard options:
# FF_CFG_FLAGS="$FF_CFG_FLAGS --prefix=$FF_PREFIX"

# # Advanced options (experts only):
# FF_CFG_FLAGS="$FF_CFG_FLAGS --cross-prefix=${FF_CROSS_PREFIX}-"
# FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-cross-compile"
# FF_CFG_FLAGS="$FF_CFG_FLAGS --target-os=linux"
# FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-pic"
# # FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-symver"

# if [ "$FF_ARCH" = "x86" ]; then
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-asm"
# else
#     # Optimization options (experts only):
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-asm"
#     FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-inline-asm"
# fi

# case "$FF_BUILD_OPT" in
#     debug)
#         FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-optimizations"
#         FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-debug"
#         FF_CFG_FLAGS="$FF_CFG_FLAGS --disable-small"
#     ;;
#     *)
#         FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-optimizations"
#         FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-debug"
#         FF_CFG_FLAGS="$FF_CFG_FLAGS --enable-small"
#     ;;
# esac

# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] configurate ffmpeg"
# echo "--------------------"
# # /Users/biezhihua/StudySpace/ijkplayer/android/contrib/ffmpeg-armv7a
# cd $FF_SOURCE
# if [ -f "./config.h" ]; then
#     echo 'reuse configure'
# else
#     # CC arm-linux-androideabi-gcc
#     # FF_CFLAGS 
#     # --arch=arm --cpu=cortex-a8 --enable-neon --enable-thumb --disable-gpl 
#     # --disable-nonfree --enable-runtime-cpudetect --disable-gray --disable-swscale-alpha 
#     # --disable-programs --disable-ffmpeg --disable-ffplay --disable-ffprobe --disable-doc 
#     # --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages 
#     # --disable-avdevice --enable-avcodec --enable-avformat --enable-avutil --enable-swresample 
#     # --enable-swscale --disable-postproc --enable-avfilter --disable-avresample --enable-network
#     # --disable-d3d11va --disable-dxva2 --disable-vaapi --disable-vda --disable-vdpau --disable-videotoolbox 
#     # --disable-encoders --enable-encoder=png --disable-decoders --enable-decoder=aac --enable-decoder=aac_latm 
#     # --enable-decoder=flv --enable-decoder=h264 --enable-decoder=mp3* --enable-decoder=vp6f --enable-decoder=flac 
#     # --enable-decoder=hevc --enable-decoder=vp8 --enable-decoder=vp9 --disable-hwaccels --disable-muxers 
#     # --enable-muxer=mp4 --disable-demuxers --enable-demuxer=aac --enable-demuxer=concat --enable-demuxer=data 
#     # --enable-demuxer=flv --enable-demuxer=hls --enable-demuxer=live_flv --enable-demuxer=mov --enable-demuxer=mp3  
#     # --enable-demuxer=mpegps --enable-demuxer=mpegts --enable-demuxer=mpegvideo --enable-demuxer=flac 
#     # --enable-demuxer=hevc --enable-demuxer=webm_dash_manifest --disable-parsers --enable-parser=aac 
#     # --enable-parser=aac_latm --enable-parser=h264 --enable-parser=flac --enable-parser=hevc --enable-bsfs 
#     # --disable-bsf=chomp --disable-bsf=dca_core --disable-bsf=dump_extradata --disable-bsf=hevc_mp4toannexb 
#     # --disable-bsf=imx_dump_header --disable-bsf=mjpeg2jpeg --disable-bsf=mjpega_dump_header 
#     # --disable-bsf=mov2textsub --disable-bsf=mp3_header_decompress --disable-bsf=mpeg4_unpack_bframes 
#     # --disable-bsf=noise --disable-bsf=remove_extradata --disable-bsf=text2movsub --disable-bsf=vp9_superframe 
#     # --enable-protocols --enable-protocol=async --disable-protocol=bluray --disable-protocol=concat -
#     # --disable-protocol=crypto --disable-protocol=ffrtmpcrypt --enable-protocol=ffrtmphttp --disable-protocol=gopher 
#     # --disable-protocol=icecast --disable-protocol=librtmp* --disable-protocol=libssh --disable-protocol=md5 
#     # --disable-protocol=mmsh --disable-protocol=mmst --disable-protocol=rtmp* --enable-protocol=rtmp 
#     # --enable-protocol=rtmpt --disable-protocol=rtp --disable-protocol=sctp --disable-protocol=srtp 
#     # --disable-protocol=subfile --disable-protocol=unix --disable-devices --disable-filters --disable-iconv 
#     # --disable-audiotoolbox --disable-videotoolbox --disable-linux-perf --disable-bzlib 
#     # --prefix=/Users/biezhihua/StudySpace/ijkplayer/android/contrib/build/ffmpeg-armv7a/output 
#     # --cross-prefix=arm-linux-androideabi- --enable-cross-compile --target-os=linux --enable-pic --enable-asm 
#     # --enable-inline-asm --enable-optimizations --enable-debug --enable-small
#     # FF_EXTRA_CFLAGS -O3 -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack -DANDROID -DNDEBUG
#     # FF_DEP_LIBS -march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb
#     # FF_EXTRA_LDFLAGS -Wl,--fix-cortex-a8
#     which $CC
#     ./configure $FF_CFG_FLAGS \
#         --extra-cflags="$FF_CFLAGS $FF_EXTRA_CFLAGS" \
#         --extra-ldflags="$FF_DEP_LIBS $FF_EXTRA_LDFLAGS"
#     make clean
# fi

# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] compile ffmpeg"
# echo "--------------------"

# # FF_PREFIX /Users/biezhihua/StudySpace/ijkplayer/android/contrib/build/ffmpeg-armv7a/output
# # FF_MAKE_FLAGS -j8

# cp config.* $FF_PREFIX
# make $FF_MAKE_FLAGS > /dev/null
# make install
# mkdir -p $FF_PREFIX/include/libffmpeg
# cp -f config.h $FF_PREFIX/include/libffmpeg/config.h

# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] link ffmpeg"
# echo "--------------------"
# echo $FF_EXTRA_LDFLAGS

# FF_C_OBJ_FILES=
# FF_ASM_OBJ_FILES=
# for MODULE_DIR in $FF_MODULE_DIRS
# do
#     C_OBJ_FILES="$MODULE_DIR/*.o"
#     if ls $C_OBJ_FILES 1> /dev/null 2>&1; then
#         echo "link $MODULE_DIR/*.o"
#         FF_C_OBJ_FILES="$FF_C_OBJ_FILES $C_OBJ_FILES"
#     fi

#     for ASM_SUB_DIR in $FF_ASSEMBLER_SUB_DIRS
#     do
#         ASM_OBJ_FILES="$MODULE_DIR/$ASM_SUB_DIR/*.o"
#         if ls $ASM_OBJ_FILES 1> /dev/null 2>&1; then
#             echo "link $MODULE_DIR/$ASM_SUB_DIR/*.o"
#             FF_ASM_OBJ_FILES="$FF_ASM_OBJ_FILES $ASM_OBJ_FILES"
#         fi
#     done
# done

# # FF_C_OBJ_FILES compat/strtod.o libavcodec/aac_ac3_parser.o libavcodec/aac_adtstoasc_bsf.o libavcodec/aac_parser.o libavcodec/aacadtsdec.o libavcodec/aacdec.o libavcodec/aacps_float.o libavcodec/aacpsdsp_float.o libavcodec/aacsbr.o libavcodec/aactab.o libavcodec/ac3tab.o libavcodec/allcodecs.o libavcodec/audioconvert.o libavcodec/avdct.o libavcodec/avfft.o libavcodec/avpacket.o libavcodec/avpicture.o libavcodec/bitstream.o libavcodec/bitstream_filter.o libavcodec/bitstream_filters.o libavcodec/blockdsp.o libavcodec/bsf.o libavcodec/bswapdsp.o libavcodec/cabac.o libavcodec/cbrt_data.o libavcodec/codec_desc.o libavcodec/d3d11va.o libavcodec/dct.o libavcodec/dct32_fixed.o libavcodec/dct32_float.o libavcodec/decode.o libavcodec/dirac.o libavcodec/dv_profile.o libavcodec/encode.o libavcodec/error_resilience.o libavcodec/extract_extradata_bsf.o libavcodec/faandct.o libavcodec/faanidct.o libavcodec/fdctdsp.o libavcodec/fft_fixed.o libavcodec/fft_fixed_32.o libavcodec/fft_float.o libavcodec/fft_init_table.o libavcodec/flac.o libavcodec/flac_parser.o libavcodec/flacdata.o libavcodec/flacdec.o libavcodec/flacdsp.o libavcodec/flvdec.o libavcodec/frame_thread_encoder.o libavcodec/golomb.o libavcodec/h263.o libavcodec/h263_parser.o libavcodec/h263data.o libavcodec/h263dec.o libavcodec/h263dsp.o libavcodec/h2645_parse.o libavcodec/h264_cabac.o libavcodec/h264_cavlc.o libavcodec/h264_direct.o libavcodec/h264_loopfilter.o libavcodec/h264_mb.o libavcodec/h264_mp4toannexb_bsf.o libavcodec/h264_parse.o libavcodec/h264_parser.o libavcodec/h264_picture.o libavcodec/h264_ps.o libavcodec/h264_refs.o libavcodec/h264_sei.o libavcodec/h264_slice.o libavcodec/h264chroma.o libavcodec/h264data.o libavcodec/h264dec.o libavcodec/h264dsp.o libavcodec/h264idct.o libavcodec/h264pred.o libavcodec/h264qpel.o libavcodec/hevc_cabac.o libavcodec/hevc_data.o libavcodec/hevc_filter.o libavcodec/hevc_mvs.o libavcodec/hevc_parse.o libavcodec/hevc_parser.o libavcodec/hevc_ps.o libavcodec/hevc_refs.o libavcodec/hevc_sei.o libavcodec/hevcdec.o libavcodec/hevcdsp.o libavcodec/hevcpred.o libavcodec/hpeldsp.o libavcodec/huffman.o libavcodec/idctdsp.o libavcodec/imgconvert.o libavcodec/intelh263dec.o libavcodec/ituh263dec.o libavcodec/jfdctfst.o libavcodec/jfdctint.o libavcodec/jni.o libavcodec/jrevdct.o libavcodec/kbdwin.o libavcodec/latm_parser.o libavcodec/lossless_videoencdsp.o libavcodec/mathtables.o libavcodec/mdct15.o libavcodec/mdct_fixed.o libavcodec/mdct_fixed_32.o libavcodec/mdct_float.o libavcodec/me_cmp.o libavcodec/mediacodec.o libavcodec/mjpegenc_huffman.o libavcodec/mpeg12framerate.o libavcodec/mpeg4audio.o libavcodec/mpeg4video.o libavcodec/mpeg4videodec.o libavcodec/mpeg_er.o libavcodec/mpegaudio.o libavcodec/mpegaudio_parser.o libavcodec/mpegaudiodata.o libavcodec/mpegaudiodec_fixed.o libavcodec/mpegaudiodec_float.o libavcodec/mpegaudiodecheader.o libavcodec/mpegaudiodsp.o libavcodec/mpegaudiodsp_data.o libavcodec/mpegaudiodsp_fixed.o libavcodec/mpegaudiodsp_float.o libavcodec/mpegpicture.o libavcodec/mpegutils.o libavcodec/mpegvideo.o libavcodec/mpegvideo_motion.o libavcodec/mpegvideodata.o libavcodec/mpegvideodsp.o libavcodec/null_bsf.o libavcodec/options.o libavcodec/parser.o libavcodec/pixblockdsp.o libavcodec/png.o libavcodec/pngenc.o libavcodec/profiles.o libavcodec/pthread.o libavcodec/pthread_frame.o libavcodec/pthread_slice.o libavcodec/qpeldsp.o libavcodec/qsv_api.o libavcodec/raw.o libavcodec/rdft.o libavcodec/resample.o libavcodec/resample2.o libavcodec/rl.o libavcodec/sbrdsp.o libavcodec/simple_idct.o libavcodec/sinewin.o libavcodec/sinewin_fixed.o libavcodec/startcode.o libavcodec/utils.o libavcodec/v4l2_buffers.o libavcodec/v4l2_context.o libavcodec/v4l2_fmt.o libavcodec/v4l2_m2m.o libavcodec/videodsp.o libavcodec/vorbis_data.o libavcodec/vorbis_parser.o libavcodec/vp3dsp.o libavcodec/vp56.o libavcodec/vp56data.o libavcodec/vp56dsp.o libavcodec/vp56rac.o libavcodec/vp6.o libavcodec/vp6dsp.o libavcodec/vp8.o libavcodec/vp8dsp.o libavcodec/vp9.o libavcodec/vp9_parser.o libavcodec/vp9_raw_reorder_bsf.o libavcodec/vp9_superframe_split_bsf.o libavcodec/vp9block.o libavcodec/vp9data.o libavcodec/vp9dsp.o libavcodec/vp9dsp_10bpp.o libavcodec/vp9dsp_12bpp.o libavcodec/vp9dsp_8bpp.o libavcodec/vp9lpf.o libavcodec/vp9mvs.o libavcodec/vp9prob.o libavcodec/vp9recon.o libavcodec/xiph.o libavfilter/allfilters.o libavfilter/audio.o libavfilter/avfilter.o libavfilter/avfiltergraph.o libavfilter/buffersink.o libavfilter/buffersrc.o libavfilter/drawutils.o libavfilter/fifo.o libavfilter/formats.o libavfilter/framepool.o libavfilter/framequeue.o libavfilter/graphdump.o libavfilter/graphparser.o libavfilter/opencl_allkernels.o libavfilter/pthread.o libavfilter/transform.o libavfilter/video.o libavformat/aacdec.o libavformat/allformats.o libavformat/apetag.o libavformat/async.o libavformat/avc.o libavformat/avio.o libavformat/aviobuf.o libavformat/cache.o libavformat/concatdec.o libavformat/cutils.o libavformat/data_uri.o libavformat/dump.o libavformat/file.o libavformat/flac_picture.o libavformat/flacdec.o libavformat/flvdec.o libavformat/format.o libavformat/ftp.o libavformat/hevc.o libavformat/hevcdec.o libavformat/hls.o libavformat/hlsproto.o libavformat/http.o libavformat/httpauth.o libavformat/id3v1.o libavformat/id3v2.o libavformat/ijkutils.o libavformat/img2.o libavformat/isom.o libavformat/matroska.o libavformat/matroskadec.o libavformat/metadata.o libavformat/mov.o libavformat/mov_chan.o libavformat/movenc.o libavformat/movenccenc.o libavformat/movenchint.o libavformat/mp3dec.o libavformat/mpeg.o libavformat/mpegts.o libavformat/mpegvideodec.o libavformat/mux.o libavformat/network.o libavformat/oggparsevorbis.o libavformat/options.o libavformat/os_support.o libavformat/prompeg.o libavformat/protocols.o libavformat/qtpalette.o libavformat/rawdec.o libavformat/rawutils.o libavformat/replaygain.o libavformat/riff.o libavformat/riffdec.o libavformat/riffenc.o libavformat/rmsipr.o libavformat/rtmphttp.o libavformat/rtmppkt.o libavformat/rtmpproto.o libavformat/rtp.o libavformat/rtpenc_chain.o libavformat/sdp.o libavformat/tcp.o libavformat/tee_common.o libavformat/teeproto.o libavformat/udp.o libavformat/url.o libavformat/urldecode.o libavformat/utils.o libavformat/vorbiscomment.o libavformat/vpcc.o libavutil/adler32.o libavutil/aes.o libavutil/aes_ctr.o libavutil/application.o libavutil/audio_fifo.o libavutil/avstring.o libavutil/base64.o libavutil/blowfish.o libavutil/bprint.o libavutil/buffer.o libavutil/camellia.o libavutil/cast5.o libavutil/channel_layout.o libavutil/color_utils.o libavutil/cpu.o libavutil/crc.o libavutil/des.o libavutil/dict.o libavutil/display.o libavutil/dns_cache.o libavutil/downmix_info.o libavutil/error.o libavutil/eval.o libavutil/fifo.o libavutil/file.o libavutil/file_open.o libavutil/fixed_dsp.o libavutil/float_dsp.o libavutil/frame.o libavutil/hash.o libavutil/hmac.o libavutil/hwcontext.o libavutil/imgutils.o libavutil/integer.o libavutil/intmath.o libavutil/lfg.o libavutil/lls.o libavutil/log.o libavutil/log2_tab.o libavutil/lzo.o libavutil/mastering_display_metadata.o libavutil/mathematics.o libavutil/md5.o libavutil/mem.o libavutil/murmur3.o libavutil/opt.o libavutil/parseutils.o libavutil/pixdesc.o libavutil/pixelutils.o libavutil/random_seed.o libavutil/rational.o libavutil/rc4.o libavutil/reverse.o libavutil/ripemd.o libavutil/samplefmt.o libavutil/sha.o libavutil/sha512.o libavutil/slicethread.o libavutil/spherical.o libavutil/stereo3d.o libavutil/tea.o libavutil/threadmessage.o libavutil/time.o libavutil/timecode.o libavutil/tree.o libavutil/twofish.o libavutil/utils.o libavutil/xga_font_data.o libavutil/xtea.o libswresample/audioconvert.o libswresample/dither.o libswresample/options.o libswresample/rematrix.o libswresample/resample.o libswresample/resample_dsp.o libswresample/swresample.o libswresample/swresample_frame.o libswscale/alphablend.o libswscale/gamma.o libswscale/hscale.o libswscale/hscale_fast_bilinear.o libswscale/input.o libswscale/options.o libswscale/output.o libswscale/rgb2rgb.o libswscale/slice.o libswscale/swscale.o libswscale/swscale_unscaled.o libswscale/utils.o libswscale/vscale.o libswscale/yuv2rgb.o
# # FF_ASM_OBJ_FILES libavcodec/arm/aacpsdsp_init_arm.o libavcodec/arm/aacpsdsp_neon.o libavcodec/arm/blockdsp_init_arm.o libavcodec/arm/blockdsp_init_neon.o libavcodec/arm/blockdsp_neon.o libavcodec/arm/fft_fixed_init_arm.o libavcodec/arm/fft_fixed_neon.o libavcodec/arm/fft_init_arm.o libavcodec/arm/fft_neon.o libavcodec/arm/fft_vfp.o libavcodec/arm/flacdsp_arm.o libavcodec/arm/flacdsp_init_arm.o libavcodec/arm/h264chroma_init_arm.o libavcodec/arm/h264cmc_neon.o libavcodec/arm/h264dsp_init_arm.o libavcodec/arm/h264dsp_neon.o libavcodec/arm/h264idct_neon.o libavcodec/arm/h264pred_init_arm.o libavcodec/arm/h264pred_neon.o libavcodec/arm/h264qpel_init_arm.o libavcodec/arm/h264qpel_neon.o libavcodec/arm/hevcdsp_deblock_neon.o libavcodec/arm/hevcdsp_idct_neon.o libavcodec/arm/hevcdsp_init_arm.o libavcodec/arm/hevcdsp_init_neon.o libavcodec/arm/hevcdsp_qpel_neon.o libavcodec/arm/hpeldsp_arm.o libavcodec/arm/hpeldsp_armv6.o libavcodec/arm/hpeldsp_init_arm.o libavcodec/arm/hpeldsp_init_armv6.o libavcodec/arm/hpeldsp_init_neon.o libavcodec/arm/hpeldsp_neon.o libavcodec/arm/idctdsp_arm.o libavcodec/arm/idctdsp_armv6.o libavcodec/arm/idctdsp_init_arm.o libavcodec/arm/idctdsp_init_armv5te.o libavcodec/arm/idctdsp_init_armv6.o libavcodec/arm/idctdsp_init_neon.o libavcodec/arm/idctdsp_neon.o libavcodec/arm/jrevdct_arm.o libavcodec/arm/mdct_fixed_neon.o libavcodec/arm/mdct_neon.o libavcodec/arm/mdct_vfp.o libavcodec/arm/me_cmp_armv6.o libavcodec/arm/me_cmp_init_arm.o libavcodec/arm/mpegaudiodsp_fixed_armv6.o libavcodec/arm/mpegaudiodsp_init_arm.o libavcodec/arm/mpegvideo_arm.o libavcodec/arm/mpegvideo_armv5te.o libavcodec/arm/mpegvideo_armv5te_s.o libavcodec/arm/mpegvideo_neon.o libavcodec/arm/pixblockdsp_armv6.o libavcodec/arm/pixblockdsp_init_arm.o libavcodec/arm/rdft_init_arm.o libavcodec/arm/rdft_neon.o libavcodec/arm/sbrdsp_init_arm.o libavcodec/arm/sbrdsp_neon.o libavcodec/arm/simple_idct_arm.o libavcodec/arm/simple_idct_armv5te.o libavcodec/arm/simple_idct_armv6.o libavcodec/arm/simple_idct_neon.o libavcodec/arm/startcode_armv6.o libavcodec/arm/videodsp_armv5te.o libavcodec/arm/videodsp_init_arm.o libavcodec/arm/videodsp_init_armv5te.o libavcodec/arm/vp3dsp_init_arm.o libavcodec/arm/vp3dsp_neon.o libavcodec/arm/vp6dsp_init_arm.o libavcodec/arm/vp6dsp_neon.o libavcodec/arm/vp8_armv6.o libavcodec/arm/vp8dsp_armv6.o libavcodec/arm/vp8dsp_init_arm.o libavcodec/arm/vp8dsp_init_armv6.o libavcodec/arm/vp8dsp_init_neon.o libavcodec/arm/vp8dsp_neon.o libavcodec/arm/vp9dsp_init_10bpp_arm.o libavcodec/arm/vp9dsp_init_12bpp_arm.o libavcodec/arm/vp9dsp_init_arm.o libavcodec/arm/vp9itxfm_16bpp_neon.o libavcodec/arm/vp9itxfm_neon.o libavcodec/arm/vp9lpf_16bpp_neon.o libavcodec/arm/vp9lpf_neon.o libavcodec/arm/vp9mc_16bpp_neon.o libavcodec/arm/vp9mc_neon.o libavutil/arm/cpu.o libavutil/arm/float_dsp_init_arm.o libavutil/arm/float_dsp_init_neon.o libavutil/arm/float_dsp_init_vfp.o libavutil/arm/float_dsp_neon.o libavutil/arm/float_dsp_vfp.o libswresample/arm/audio_convert_init.o libswresample/arm/audio_convert_neon.o libswresample/arm/resample.o libswresample/arm/resample_init.o libswscale/arm/hscale.o libswscale/arm/output.o libswscale/arm/rgb2yuv_neon_16.o libswscale/arm/rgb2yuv_neon_32.o libswscale/arm/swscale.o libswscale/arm/swscale_unscaled.o libswscale/arm/yuv2rgb_neon.o
# # FF_SYSROOT /Users/biezhihua/StudySpace/ijkplayer/android/contrib/build/ffmpeg-armv7a/toolchain/sysroot
# echo `pwd`
# echo $CC
# echo $FF_SYSROOT
# echo $FF_SYSROOT/usr/include/$FF_CROSS_PREFIX
# echo $FF_EXTRA_LDFLAGS
# echo $FF_DEP_LIBS

# $CC -lm -lz -shared --sysroot=$FF_SYSROOT \
#     -Wl,-z,noexecstack \
#     $FF_EXTRA_LDFLAGS \
#     -Wl,-soname,libijkffmpeg.so \
#     $FF_C_OBJ_FILES \
#     $FF_ASM_OBJ_FILES \
#     $FF_DEP_LIBS \
#     -o $FF_PREFIX/libijkffmpeg.so

# mysedi() {
#     f=$1
#     exp=$2
#     n=`basename $f`
#     cp $f /tmp/$n
#     sed $exp /tmp/$n > $f
#     rm /tmp/$n
# }

# echo ""
# echo "--------------------"
# echo "[*] create files for shared ffmpeg"
# echo "--------------------"
# rm -rf $FF_PREFIX/shared
# mkdir -p $FF_PREFIX/shared/lib/pkgconfig
# ln -s $FF_PREFIX/include $FF_PREFIX/shared/include
# ln -s $FF_PREFIX/libijkffmpeg.so $FF_PREFIX/shared/lib/libijkffmpeg.so
# cp $FF_PREFIX/lib/pkgconfig/*.pc $FF_PREFIX/shared/lib/pkgconfig
# for f in $FF_PREFIX/lib/pkgconfig/*.pc; do
#     # in case empty dir
#     if [ ! -f $f ]; then
#         continue
#     fi
#     cp $f $FF_PREFIX/shared/lib/pkgconfig
#     f=$FF_PREFIX/shared/lib/pkgconfig/`basename $f`
#     # OSX sed doesn't have in-place(-i)
#     mysedi $f 's/\/output/\/output\/shared/g'
#     mysedi $f 's/-lavcodec/-lijkffmpeg/g'
#     mysedi $f 's/-lavfilter/-lijkffmpeg/g'
#     mysedi $f 's/-lavformat/-lijkffmpeg/g'
#     mysedi $f 's/-lavutil/-lijkffmpeg/g'
#     mysedi $f 's/-lswresample/-lijkffmpeg/g'
#     mysedi $f 's/-lswscale/-lijkffmpeg/g'
# done
