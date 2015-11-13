#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

pushd ${SCRIPT_DIR}
OPENSSL_VERSION=1.0.1e
FIPS_VERSION=2.0.5

FIPS_INSTALL_DIR=${SCRIPT_DIR}/fips_install
INSTALL_DIR=${SCRIPT_DIR}/openssl_install

rm -Rf openssl-fips-${FIPS_VERSION}
rm -Rf openssl-${OPENSSL_VERSION}
rm -Rf ${FIPS_INSTALL_DIR}
rm -Rf ${INSTALL_DIR}

tar xzf openssl-fips-${FIPS_VERSION}.tar.gz


export FIPS_SIG=${SCRIPT_DIR}/openssl-fips-${FIPS_VERSION}/util/incore


. ./setenv-android.sh
pushd openssl-fips-${FIPS_VERSION}
./config --prefix=${FIPS_INSTALL_DIR}/
make

make install
cp $FIPS_SIG ${FIPS_INSTALL_DIR}/bin
popd
#cp -R /usr/local/ssl/fips-2.0 fips-2.0
#cp ${FIPS_SIG} fips-2.0/bin


tar xzf openssl-${OPENSSL_VERSION}.tar.gz
. ./setenv-android.sh
pushd openssl-${OPENSSL_VERSION}
perl -pi -e 's/install: all install_docs install_sw/install: install_sw/g' Makefile.org
./config fips --with-fipsdir=${FIPS_INSTALL_DIR}/ --prefix=${INSTALL_DIR}/
make depend
make all
make install CC=$ANDROID_TOOLCHAIN/arm-linux-androideabi-gcc RANLIB=$ANDROID_TOOLCHAIN/arm-linux-androideabi-ranlib
popd
# cp -R /usr/local/ssl ${OPENSSL_INSTALL_DIR}


popd






