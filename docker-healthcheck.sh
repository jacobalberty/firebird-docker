#!/usr/bin/env bash
CONFIG=/firebird/etc/docker-healthcheck.conf
ISQL=/usr/local/firebird/bin/isql
HC_IP=127.0.0.1
HC_PORT=3050
if [[ -f "${CONFIG}" ]]; then
    . "${CONFIG}"
# This is a "safer" option that does not allow shell scripting in the conf file
#    export $(cat "${CONFIG}" | grep -v ^# | xargs)
fi
if [[ -z "${HC_USER}" || -z "${HC_PASS}" || -z "${HC_DB}" ]]; then
  # Default when no user/pass/db is specified
  nc -z "${HC_IP}" "${HC_PORT}" < /dev/null
  exit $?
else
  FB_RESULT=`${ISQL} -user "${HC_USER}" -password "${HC_PASS}" "${HC_IP}/${HC_PORT}:${HC_DB}" << "EOF"
  SHOW DATABASE;
EOF
  `
  exit $?
fi
