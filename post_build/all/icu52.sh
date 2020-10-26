#!/usr/bin/env bash
ICU_URL="https://github.com/unicode-org/icu/releases/download/release-52-2/icu4c-52_2-src.tgz"

CPUC=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)

apt-get purge -qy --auto-remove libicu63

mkdir -p /home/icu52
cd /home/icu52
curl -L -o icu4c.tar.gz -L "${ICU_URL}"
tar --strip=1 -xf icu4c.tar.gz
cd source
./configure
make -j${CPUC}
make install

cd /
rm -rf /home/icu52

