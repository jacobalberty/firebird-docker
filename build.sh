#!/usr/bin/env bash
set -e
declare -A DEBARCHS=( ["linux/arm64"]="arm64" ["linux/arm/v7"]="armhf" ["linux/amd64"]="amd64" )
declare -A CONFARCHS=( ["linux/arm64"]="aarch64-unknown-linux-gnu" ["linux/arm/v7"]="arm-linux-gnueabihf" ["linux/amd64"]="x86_64-linux-gnu" )
declare -A PREFARCHS=( ["linux/arm64"]="aarch64-linux-gnu" ["linux/arm/v7"]="arm-linux-gnueabihf" ["linux/amd64"]="x86_64-linux-gnu" )
DEBARCH="${DEBARCHS[${TARGETPLATFORM}]}"

CPUC=$(getconf _NPROCESSORS_ONLN)

apt-get update
apt-get install -qy --no-install-recommends \
    libatomic1 \
    libicu67 \
    libncurses6 \
    libtomcrypt1 \
    libtommath1 \
    netbase \
    procps

apt-get install -qy --no-install-recommends \
    ca-certificates \
    curl \
    g++ \
    gcc \
    libicu-dev \
    libncurses-dev \
    libtomcrypt-dev \
    libtommath-dev \
    make \
    unzip \
    xz-utils \
    zlib1g-dev
if [ -d "/home/fixes/pre_fetch/${DEBARCH}" ]; then
    find "/home/fixes/pre_fetch/${DEBARCH}" -type f -exec '{}' \;
fi
if [ -d "/home/fixes/pre_fetch/all" ]; then
    find "/home/fixes/pre_fetch/all" -type f -exec '{}' \;
fi
mkdir -p /home/firebird
cd /home/firebird
curl -L -o firebird-source.tar.xz -L \
    "${FBURL}"
tar --strip=1 -xf firebird-source.tar.xz
if [ -d "/home/fixes/pre_build/${DEBARCH}" ]; then
    find "/home/fixes/pre_build/${DEBARCH}" -type f -exec '{}' \;
fi
if [ -d "/home/fixes/pre_build/all" ]; then
    find "/home/fixes/pre_build/all" -type f -exec '{}' \;
fi
if [ "${TARGETPLATFORM}" != "${BUILDPLATFORM}" ]; then
    dpkg --add-architecture "$DEBARCH"
    apt-get update
    apt-get install -qy \
        "crossbuild-essential-$DEBARCH" \
        libicu-dev:"$DEBARCH" \
        libncurses-dev:"$DEBARCH" \
        libtomcrypt-dev:"$DEBARCH" \
        libtommath-dev:"$DEBARCH" \
        zlib1g-dev:"$DEBARCH"
    update-alternatives --install /usr/bin/objcopy objcopy "/usr/bin/${PREFARCHS[${TARGETPLATFORM}]}-objcopy" 20
    export CXX="${PREFARCHS[${TARGETPLATFORM}]}-g++"
    export CC="${PREFARCHS[${TARGETPLATFORM}]}-gcc"
    ./configure \
        --prefix="${PREFIX}"/ --with-fbbin="${PREFIX}"/bin/ --with-fbsbin="${PREFIX}"/bin/ --with-fblib="${PREFIX}"/lib/ \
        --with-fbinclude="${PREFIX}"/include/ --with-fbdoc="${PREFIX}"/doc/ --with-fbudf="${PREFIX}"/UDF/ \
        --with-fbsample="${PREFIX}"/examples/ --with-fbsample-db="${PREFIX}"/examples/empbuild/ --with-fbhelp="${PREFIX}"/help/ \
        --with-fbintl="${PREFIX}"/intl/ --with-fbmisc="${PREFIX}"/misc/ --with-fbplugins="${PREFIX}"/ \
        --with-fbconf="${VOLUME}/etc/" --with-fbmsg="${PREFIX}"/ \
        --with-fblog="${VOLUME}/log/" --with-fbglock=/var/firebird/run/ \
        --with-fbsecure-db="${VOLUME}/system" \
        --host="${CONFARCHS[${TARGETPLATFORM}]}" --target="${CONFARCHS[${TARGETPLATFORM}]}" --build="${CONFARCHS[${TARGETPLATFORM}]}"
else
    ./configure \
        --prefix="${PREFIX}"/ --with-fbbin="${PREFIX}"/bin/ --with-fbsbin="${PREFIX}"/bin/ --with-fblib="${PREFIX}"/lib/ \
        --with-fbinclude="${PREFIX}"/include/ --with-fbdoc="${PREFIX}"/doc/ --with-fbudf="${PREFIX}"/UDF/ \
        --with-fbsample="${PREFIX}"/examples/ --with-fbsample-db="${PREFIX}"/examples/empbuild/ --with-fbhelp="${PREFIX}"/help/ \
        --with-fbintl="${PREFIX}"/intl/ --with-fbmisc="${PREFIX}"/misc/ --with-fbplugins="${PREFIX}"/ \
        --with-fbconf="${VOLUME}/etc/" --with-fbmsg="${PREFIX}"/ \
        --with-fblog="${VOLUME}/log/" --with-fbglock=/var/firebird/run/ \
        --with-fbsecure-db="${VOLUME}/system"
fi
make -j"${CPUC}"
cd gen
make -f Makefile.install tarfile
mv ./*.tar.gz ../firebird.tar.gz
cd ..

