#!/bin/bash
set -e

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

confSet() {
    confFile="${VOLUME}/etc/firebird.conf"
    # Uncomment specified value
    sed -i "s/^#${1}/${1}/g" "${confFile}"
    # Set Value to new value
    sed -i "s~^\(${1}\s*=\s*\).*$~\1${2}~" "${confFile}"
}

# Create any missing folders
mkdir -p "${VOLUME}/system"
mkdir -p "${VOLUME}/log"
mkdir -p "${VOLUME}/data"
if [[ ! -e "${VOLUME}/etc/" ]]; then
    cp -R "${PREFIX}/skel/etc" "${VOLUME}/"
    file_env 'EnableLegacyClientAuth'
    file_env 'EnableWireCrypt'
    if [[ ${EnableLegacyClientAuth} == 'true' ]]; then
        confSet AuthServer "Legacy_Auth, Srp, Win_Sspi"
        confSet AuthClient "Legacy_Auth, Srp, Win_Sspi"
        confSet UserManager "Legacy_UserManager, Srp"
        confSet WireCrypt "enabled"
    fi
    if [[ ${EnableWireCrypt} == 'true' ]]; then
        confSet WireCrypt "enabled"
    fi
fi

if [ ! -f "${VOLUME}/system/security3.fdb" ]; then
    cp "${PREFIX}/skel/security3.fdb" "${VOLUME}/system/security3.fdb"
    file_env 'ISC_PASSWORD'
    if [ -z ${ISC_PASSWORD} ]; then
       ISC_PASSWORD=$(createNewPassword)
       echo "setting 'SYSDBA' password to '${ISC_PASSWORD}'"
    fi

    # initialize SYSDBA user for Srp authentication
    ${PREFIX}/bin/isql -user sysdba "${VOLUME}/system/security3.fdb" <<EOL
create or alter user SYSDBA password '${ISC_PASSWORD}' using plugin Srp;
commit;
quit;
EOL

    if [[ ${EnableLegacyClientAuth} == 'true' ]]; then
        # also initialize/reset SYSDBA user for legacy authentication
        ${PREFIX}/bin/isql -user sysdba "${VOLUME}/system/security3.fdb" <<EOL
create or alter user SYSDBA password '${ISC_PASSWORD}' using plugin Legacy_UserManager;
commit;
quit;
EOL
    fi
# create or alter user SYSDBA password '${ISC_PASSWORD}';

    cat > "${VOLUME}/etc/SYSDBA.password" <<EOL
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

if [ -f "${VOLUME}/etc/SYSDBA.password" ]; then
    source "${VOLUME}/etc/SYSDBA.password"
fi;

file_env 'FIREBIRD_USER'
file_env 'FIREBIRD_PASSWORD'
file_env 'FIREBIRD_DATABASE'

build isql "set sql dialect 3;"
if [ ! -z "${FIREBIRD_DATABASE}" -a ! -f "${DBPATH}/${FIREBIRD_DATABASE}" ]; then
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
    fi
    stmt+=" DEFAULT CHARACTER SET UTF8;";
    build isql "${stmt}";
    build isql "COMMIT;"
    if [ "${isql}" ]; then
        build isql "QUIT;"
        run isql
    fi
fi

$@
