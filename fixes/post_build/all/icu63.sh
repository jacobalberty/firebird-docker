#!/usr/bin/env bash
ICU_URL="https://github.com/unicode-org/icu/releases/download/release-63-2/icu4c-63_2-src.tgz"

CPUC=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)

apt-get purge -qy --auto-remove libicu67

mkdir -p /home/icu63
cd /home/icu63
curl -L -o icu4c.tar.gz -L "${ICU_URL}"
tar --strip=1 -xf icu4c.tar.gz
cd source
./configure
make -j${CPUC}
make install

cd /
rm -rf /home/icu63
