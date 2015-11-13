#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

pushd ${SCRIPT_DIR}
OPENSSL_VERSION=1.0.1e
FIPS_VERSION=2.0.5

OPENSSL_INSTALL_DIR=${SCRIPT_DIR}/openssl_install

rm -Rf openssl-fips-${FIPS_VERSION}
rm -Rf openssl-${OPENSSL_VERSION}

tar xzf openssl-fips-${FIPS_VERSION}.tar.gz
tar xzf openssl-${OPENSSL_VERSION}.tar.gz

FIPS_SIG=${SCRIPT_DIR}/openssl-fips-${FIPS_VERSION}/util/incore

. ./setenv-android.sh

pushd openssl-fips-${FIPS_VERSION}
./config #android-armv7
make
sudo rm -Rf /usr/local/ssl/fips-2.0
sudo make install
popd
cp -R /usr/local/ssl/fips-2.0 fips-2.0
cp ${FIPS_SIG} fips-2.0/bin


. ./setenv-android.sh
pushd openssl-${OPENSSL_VERSION}
perl -pi -e 's/install: all install_docs install_sw/install: install_sw/g' Makefile.org
./config fips --with-fipsdir=/Users/justinliu/Documents/git/openssl-android-mac/fips-2.0/
make depend
make
sudo -E make install CC=$ANDROID_TOOLCHAIN/arm-linux-androideabi-gcc RANLIB=$ANDROID_TOOLCHAIN/arm-linux-androideabi-ranlib
popd
cp -R /usr/local/ssl ${OPENSSL_INSTALL_DIR}


popd






