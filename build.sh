#!/bin/bash
set -e
CPUC=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)

apk add --no-cache \
    icu-libs \
    procps \
    shadow

apk add --no-cache --virtual=build-dependencies \
    build-base \
    curl \
    icu-dev \
    libtool \
    linux-headers \
    ncurses-dev \
    procmail \
    tar \
    zlib-dev

SRCPATH=${PREFIX}/src

mkdir -p "${SRCPATH}"
cd "${SRCPATH}"
curl -o firebird-source.tar.bz2 -L \
    "${FBURL}"
tar --strip=1 -xf firebird-source.tar.bz2

patch -p1 < ${PREFIX}/patch/musl-mode_t.patch
patch -p1 < ${PREFIX}/patch/alloc.patch
patch -p1 < ${PREFIX}/patch/narrowing.patch
patch -p1 < ${PREFIX}/patch/parallel-build.patch
./configure \
    --prefix=${PREFIX}/ --with-fbbin=${PREFIX}/bin/ --with-fbsbin=${PREFIX}/bin/ --with-fblib=${PREFIX}/lib/ \
    --with-fbinclude=${PREFIX}/include/ --with-fbdoc=${PREFIX}/doc/ --with-fbudf=${PREFIX}/UDF/ \
    --with-fbsample=${PREFIX}/examples/ --with-fbsample-db=${PREFIX}/examples/empbuild/ --with-fbhelp=${PREFIX}/help/ \
    --with-fbintl=${PREFIX}/intl/ --with-fbmisc=${PREFIX}/misc/ --with-fbplugins=${PREFIX}/ \
    --with-fbconf=/var/firebird/etc/ --with-fbmsg=${PREFIX}/ \
    --with-fblog=/var/firebird/log/ --with-fbglock=/var/firebird/run/ \
    --with-fbsecure-db=/var/firebird/system --with-builtin-tommath
CFLAGS="-fno-strict-aliasing" CXXFLAGS="-fno-delete-null-pointer-checks -fno-strict-aliasing" make -j${CPUC}
make silent_install
cd /
rm -rf "${SRCPATH}"
find "${PREFIX}" -name .debug -prune -exec rm -rf {} \;
apk del build-dependencies
apk add --no-cache \
    libgcc \
    libstdc++

# This allows us to initialize a random value for sysdba password
mv /var/firebird/system/security3.fdb ${PREFIX}/security3.fdb

# Cleaning up to restrict access to specific path and allow changing that path easily to
# something standard. See github issue https://github.com/jacobalberty/firebird-docker/issues/12
sed -i 's/^#DatabaseAccess/DatabaseAccess/g' /var/firebird/etc/firebird.conf
sed -i "s~^\(DatabaseAccess\s*=\s*\).*$~\1Restrict ${DBPATH}~" /var/firebird/etc/firebird.conf
