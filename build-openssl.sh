#!/bin/bash

export ANDROID_NDK_ROOT=/workplace/android-ndk/android-ndk-r26d

PATH=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
# echo $PATH

SOURCE_PATH_OPENSSL=/workplace/openssl/openssl_v3.4.0

TARGET_PATH_ARM64=/workplace/openssl/release_android/arm64-v8a
TARGET_PATH_ARM=/workplace/openssl/release_android/armeabi-v7a
TARGET_PATH_X86=/workplace/openssl/release_android/x86
TARGET_PATH_X86_64=/workplace/openssl/release_android/x86_64

TARGET_PATH_LINUX=/workplace/openssl/release

if [ ! -e $TARGET_PATH_ARM64 ]; then
  mkdir -p $TARGET_PATH_ARM64
fi
if [ ! -e $TARGET_PATH_ARM ]; then
  mkdir -p $TARGET_PATH_ARM
fi
if [ ! -e $TARGET_PATH_X86 ]; then
  mkdir -p $TARGET_PATH_X86
fi
if [ ! -e $TARGET_PATH_X86_64 ]; then
  mkdir -p $TARGET_PATH_X86_64
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 android" >&2
  echo "Usage: $0 linux" >&2
  exit 1
fi
if [ $1 == "android" ]; then
  echo "### build and distribute for android(arm64-v8a)"
  cd $SOURCE_PATH_OPENSSL
  make clean
  ./Configure android-arm64 enable-fips enable-tfo shared --prefix=$TARGET_PATH_ARM64
  make
  ## make test
  make install

  echo "### build and distribute for android(armeabi-v7a)"
  make clean
  ./Configure android-arm enable-fips enable-tfo shared --prefix=$TARGET_PATH_ARM
  make
  ## make test
  make install

  echo "### build and distribute for android(x86)"
  make clean
  ./Configure android-x86 enable-fips enable-tfo shared --prefix=$TARGET_PATH_X86
  make
  ## make test
  make install

  echo "### build and distribute for android(x86_64)"
  make clean
  ./Configure android-x86_64 enable-fips enable-tfo shared --prefix=$TARGET_PATH_X86_64
  make
  ## make test
  make install

  exit 0
fi
if [ $1 == "linux" ]; then
  cd $SOURCE_PATH_OPENSSL
  make clean
  ./Configure enable-fips enable-tfo shared --prefix=$TARGET_PATH_LINUX
  make
  make install
  exit 0
fi
echo "Usage: $0 android" >&2
echo "Usage: $0 linux" >&2

