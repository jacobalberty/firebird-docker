#!/bin/sh
#PREFIX=/usr/local/firebird
#DEBIAN_FRONTEND noninteractive
#FBURL=http://downloads.sourceforge.net/project/firebird/firebird/3.0.1-Release/Firebird-3.0.1.32609-0.tar.bz2

CPUC=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)

apt-get update
apt-get install -qy curl bzip2 gcc zlib1g-dev libicu-dev libtommath-dev libncurses5-dev make g++ libicu52 libtommath0
mkdir -p /home/firebird
cd /home/firebird
curl -o firebird-source.tar.bz2 -L \
    "${FBURL}"
tar --strip=1 -xf firebird-source.tar.bz2
./configure \
    --prefix=${PREFIX}/ --with-fbbin=${PREFIX}/bin/ --with-fbsbin=${PREFIX}/bin/ --with-fblib=${PREFIX}/lib/ \
    --with-fbinclude=${PREFIX}/include/ --with-fbdoc=${PREFIX}/doc/ --with-fbudf=${PREFIX}/UDF/ \
    --with-fbsample=${PREFIX}/examples/ --with-fbsample-db=${PREFIX}/examples/empbuild/ --with-fbhelp=${PREFIX}/help/ \
    --with-fbintl=${PREFIX}/intl/ --with-fbmisc=${PREFIX}/misc/ --with-fbplugins=${PREFIX}/ \
    --with-fbconf=/var/firebird/etc/ --with-fbmsg=${PREFIX}/ \
    --with-fblog=/var/firebird/log/ --with-fbglock=/var/firebird/run/ \
    --with-fbsecure-db=/var/firebird/system --with-system-icu
make -j${CPUC}
make silent_install
cd /
rm -rf /home/firebird
rm -rf ${PREFIX}/*/.debug
apt-get purge -qy --auto-remove curl bzip2 gcc zlib1g-dev libicu-dev libtommath-dev libncurses5-dev make g++
apt-get clean -q
rm -rf /var/lib/apt/lists/*
