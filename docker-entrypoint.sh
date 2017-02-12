#!/bin/bash
set -e

if [ ! -f "/var/firebird/system/security3.fdb" ]; then
    cp ${PREFIX}/security3.fdb /var/firebird/system/security3.fdb
    if [ -z ${ISC_PASSWORD} ]; then
        ISC_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    fi

    ${PREFIX}/bin/isql -user sysdba employee <<EOL
create or alter user SYSDBA password '${ISC_PASSWORD}';
commit;
quit;
EOL

    cat > /var/firebird/etc/SYSDBA.password <<EOL
# Firebird generated password for user SYSDBA is:
#
ISC_USER=sysdba
ISC_PASSWORD=${ISC_PASSWORD}
#
# Also set legacy variable though it can't be exported directly
#
ISC_PASSWD=${ISC_PASSWORD}
#
# generated at time $(date)
#
# Your password can be changed to a more suitable one using
# SQL operator ALTER USER.
#

EOL

echo "set 'SYSDBA' password to '${ISC_PASSWORD}'"

fi

$@

