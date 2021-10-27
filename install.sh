#!/usr/bin/env bash
set -e

apt-get update
apt-get install -qy --no-install-recommends \
    libatomic1 \
    libicu67 \
    libncurses6 \
    libtomcrypt1 \
    libtommath1

cd /home/firebird
tar --strip=1 -xf firebird.tar.gz
./install.sh -silent
cd /
rm -rf /home/firebird

if [ -d "/home/fixes/post_build/$(dpkg --print-architecture)" ]; then
    find "/home/fixes/post_build/$(dpkg --print-architecture)" -type f -exec '{}' \;
fi
if [ -d "/home/fixes/post_build/all" ]; then
    find "/home/fixes/post_build/all" -type f -exec '{}' \;
fi
find ${PREFIX} -name .debug -prune -exec rm -rf {} \;

rm -rf /var/lib/apt/lists/*

mkdir -p "${PREFIX}/skel/"

# This allows us to initialize a random value for sysdba password
mv "${VOLUME}/system/security4.fdb" "${PREFIX}/skel/security4.fdb"

# Cleaning up to restrict access to specific path and allow changing that path easily to
# something standard. See github issue https://github.com/jacobalberty/firebird-docker/issues/12
sed -i 's/^#DatabaseAccess/DatabaseAccess/g' "${VOLUME}/etc/firebird.conf"
sed -i "s~^\(DatabaseAccess\s*=\s*\).*$~\1Restrict ${DBPATH}~" "${VOLUME}/etc/firebird.conf"

mv "${VOLUME}/etc" "${PREFIX}/skel"
