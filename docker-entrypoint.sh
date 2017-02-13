#!/bin/bash
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

if [ ! -f "/var/firebird/system/security3.fdb" ]; then
    cp ${PREFIX}/security3.fdb /var/firebird/system/security3.fdb
    file_env 'ISC_PASSWORD'
    if [ -z ${ISC_PASSWORD} ]; then
       ISC_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
       echo "setting 'SYSDBA' password to '${ISC_PASSWORD}'"
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

fi

$@

