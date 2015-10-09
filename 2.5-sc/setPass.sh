#!/bin/bash
source /var/firebird/etc/SYSDBA.password
/usr/local/firebird/bin/gsec -user SYSDBA -password "${ISC_PASSWD}" -modify SYSDBA -pw masterkey

cat > /var/firebird/etc/SYSDBA.password <<EOL
# Firebird generated password for user SYSDBA is:

ISC_USER=SYSDBA
ISC_PASSWD=masterkey
# Your password can be changed to a more suitable one using the
# /usr/local/firebird/bin/gsec utility.

EOL

