#!/bin/bash
set -e

# SuperServer doesn't include an embedded engine in its build
# so we have to launch firebird in the background while this script runs
# fbtry and fbkill are used to quietly launch and remove firebird in the
# background and make sure its available before managing users/creating the db
pidfile=/var/run/firebird/firebird.pid

fbtry() {
    if [ -f $pidfile -a -d "/proc/`cat $pidfile`" ];  then
        return
    fi;
    ${PREFIX}/bin/fbguard -pidfile $pidfile -daemon
    # Try every second to access the firebird port, timout after 10 seconds and just hope it came up on a different port
    timeout 10 sh -c 'until nc -z $0 $1; do sleep 1; done' localhost 3050
}
fbkill() {
    if [ -f $pidfile ]; then
        pid=`cat $pidfile`
        kill "$pid" || true
        while kill -0 "$pid" 2> /dev/null; do
            sleep 0.5
        done
    fi
}

build() {
    local var="$1"
    local stmt="$2"
    export $var+="$(printf "\n${stmt}")"
}

run() {
    echo "${!1}" | ${PREFIX}/bin/isql
}

createNewPassword() {
    # openssl generates random data.
        openssl </dev/null >/dev/null 2>/dev/null
    if [ $? -eq 0 ]
    then
        # We generate 40 random chars, strip any '/''s and get the first 20
        NewPasswd=`openssl rand -base64 40 | tr -d '/' | cut -c1-20`
    fi

        # If openssl is missing...
        if [ -z "$NewPasswd" ]
        then
                NewPasswd=`dd if=/dev/urandom bs=10 count=1 2>/dev/null | od -x | head -n 1 | tr -d ' ' | cut -c8-27`
        fi

        # On some systems even this routines may be missing. So if
        # the specific one isn't available then keep the original password.
    if [ -z "$NewPasswd" ]
    then
        NewPasswd="masterkey"
    fi

        echo "$NewPasswd"
}

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

read_var() {
    local file="$1"
    local var="$2"

    echo $(source "${file}"; printf "%s" "${!var}");
}
# Create any missing folders
mkdir -p "${VOLUME}/system"
mkdir -p "${VOLUME}/log"
mkdir -p "${VOLUME}/data"
if [[ ! -e "${VOLUME}/etc/" ]]; then
    cp -R "${PREFIX}/skel/etc" "${VOLUME}/"
fi

if [ ! -f "${VOLUME}/system/security2.fdb" ]; then
    cp ${PREFIX}/skel/security2.fdb ${VOLUME}/system/security2.fdb
    chown firebird.firebird ${VOLUME}/system/security2.fdb

    file_env 'ISC_PASSWORD'
    if [ -z ${ISC_PASSWORD} ]; then
       ISC_PASSWORD=$(createNewPassword)
       echo "setting 'SYSDBA' password to '${ISC_PASSWORD}'"
    fi
    fbtry
    ${PREFIX}/bin/gsec -user SYSDBA -password "$(read_var ${VOLUME}/etc/SYSDBA.password ISC_PASSWD)" -modify SYSDBA -pw ${ISC_PASSWORD}
#    ${PREFIX}/bin/isql -user sysdba employee <<EOL
#create or alter user SYSDBA password '${ISC_PASSWORD}';
#commit;
#quit;
#EOL

    cat > ${VOLUME}/etc/SYSDBA.password <<EOL
# Firebird generated password for user SYSDBA is:

ISC_USER=SYSDBA
ISC_PASSWD=${ISC_PASSWORD}
# Your password can be changed to a more suitable one using the
# ${PREFIX}/bin/gsec utility.

# Set for interop with 3.0
ISC_PASSWORD=${ISC_PASSWORD}
EOL

fi

if [ -f "${VOLUME}/etc/SYSDBA.password" ]; then
    source ${VOLUME}/etc/SYSDBA.password
fi;

file_env 'FIREBIRD_USER'
file_env 'FIREBIRD_PASSWORD'
file_env 'FIREBIRD_DATABASE'

build isql "set sql dialect 3;"
if [ ! -z "${FIREBIRD_DATABASE}" -a ! -f "${DBPATH}/${FIREBIRD_DATABASE}" ]; then
    fbtry

    if [ "${FIREBIRD_USER}" ];  then
        build isql "CONNECT employee USER '${ISC_USER}' PASSWORD '${ISC_PASSWORD}';"
        if [ -z "${FIREBIRD_PASSWORD}" ]; then
            FIREBIRD_PASSWORD=$(createNewPassword)
            echo "setting '${FIREBIRD_USER}' password to '${FIREBIRD_PASSWORD}'"
        fi
        build isql "CREATE USER ${FIREBIRD_USER} PASSWORD '${FIREBIRD_PASSWORD}';"
        build isql "COMMIT;"
    fi

    stmt="CREATE DATABASE '${DBPATH}/${FIREBIRD_DATABASE}'"
    if [ "${FIREBIRD_USER}" ];  then
        stmt+=" USER '${FIREBIRD_USER}' PASSWORD '${FIREBIRD_PASSWORD}'"
    else
        stmt+=" USER '${ISC_USER}' PASSWORD '${ISC_PASSWORD}'"
    fi
    stmt+=" DEFAULT CHARACTER SET UTF8;";
    build isql "${stmt}";
    build isql "COMMIT;"
    if [ "${isql}" ]; then
        build isql "QUIT;"
        run isql
    fi
fi
fbkill
$@
