cd /Users/justinliu/Documents/git/openssl-android-mac 
tar xzf openssl-fips-2.0.5.tar.gz 
find $PWD -name incore
export FIPS_SIG=/Users/justinliu/Documents/git/openssl-android-mac/openssl-fips-2.0.5/util/incore
echo $FIPS_SIG
. ./setenv-android.sh 
cd openssl-fips-2.0.5
./config
make
sudo rm -Rf /usr/local/ssl
sudo make install
ls /usr/local/ssl
sudo cp $FIPS_SIG /usr/local/ssl/fips-2.0/bin
ls /usr/local/ssl/fips-2.0/bin
cd ..
. ./setenv-android.sh 
tar xzf openssl-1.0.1e.tar.gz 
cd openssl-1.0.1e
perl -pi -e 's/install: all install_docs install_sw/install: install_sw/g' Makefile.org
./config fips --with-fipsdir=/usr/local/ssl/fips-2.0/
make depend
make all
sudo -E make install CC=$ANDROID_TOOLCHAIN/arm-linux-androideabi-gcc RANLIB=$ANDROID_TOOLCHAIN/arm-linux-androideabi-ranlib

