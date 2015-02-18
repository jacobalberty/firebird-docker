#!/bin/sh
# This shell script sets the password for SYSDBA to "masterkey"
# and puts it into /etc/firebird/2.5/SYSDBA.password

FB_VER=2.5
FB_FLAVOUR=superclassic
. /usr/share/firebird${FB_VER}-common/functions.sh

#NewPassword=$(cut -c 1-8 /proc/sys/kernel/random/uuid)
#writeNewPassword "${NewPassword}"

writeNewPassword "masterkey"
enable_firebird_server

rm /setup.sh
