#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

pushd ${SCRIPT_DIR}
OPENSSL_VERSION=1.0.1k
FIPS_VERSION=2.0.10



OPENSSL_OPTIONS="threads no-shared no-hw no-dso no-krb5 no-zlib no-bf no-cast no-idea no-md2 no-mdc2 no-rc5 no-ripemd no-sctp"


export FIPS_SIG=${SCRIPT_DIR}/openssl-fips-${FIPS_VERSION}/util/incore
USE_NDK=${ANDROID_NDK}
USE_EABI_VERSION="4.8"
USE_API="android-9"
USE_ARCH="arch-x86"

# . ./setenv-android.sh -ndk $USE_NDK -arch ${USE_ARCH} --eabi-version $USE_EABI_VERSION -api $USE_API
# exit 1

FIPS_INSTALL_DIR=${SCRIPT_DIR}/fips_install/${USE_ARCH}
INSTALL_DIR=${SCRIPT_DIR}/openssl_install/${USE_ARCH}


rm -Rf openssl-fips-${FIPS_VERSION}
rm -Rf openssl-${OPENSSL_VERSION}
rm -Rf ${FIPS_INSTALL_DIR}
rm -Rf ${INSTALL_DIR}

tar xzf openssl-fips-${FIPS_VERSION}.tar.gz





. ./setenv-android.sh -ndk $USE_NDK -arch ${USE_ARCH} --eabi-version $USE_EABI_VERSION -api $USE_API
pushd openssl-fips-${FIPS_VERSION}
./config --prefix=${FIPS_INSTALL_DIR}/ ${OPENSSL_OPTIONS}
make

make install
cp $FIPS_SIG ${FIPS_INSTALL_DIR}/bin
popd


tar xzf openssl-${OPENSSL_VERSION}.tar.gz
. ./setenv-android.sh -ndk $USE_NDK -arch ${USE_ARCH} --eabi-version $USE_EABI_VERSION -api $USE_API
pushd openssl-${OPENSSL_VERSION}
perl -pi -e 's/install: all install_docs install_sw/install: install_sw/g' Makefile.org
./config fips --with-fipsdir=${FIPS_INSTALL_DIR}/ --prefix=${INSTALL_DIR}/ ${OPENSSL_OPTIONS}
make depend
make all
make install CC=$ANDROID_TOOLCHAIN/${CROSS_COMPILE}gcc RANLIB=$ANDROID_TOOLCHAIN/${CROSS_COMPILE}ranlib
popd


popd






