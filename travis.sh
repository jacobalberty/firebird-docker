#!/bin/bash
set -e
docker run -d -p 127.0.0.1:3050:3050 --name firebird firebird >> /dev/null
docker logs firebird
docker ps | grep -q firebird
docker rm -f -v firebird >> /dev/null
echo "--- Testing Database/user creation --- "
docker run -d --name firebird -e FIREBIRD_USER=testing -e FIREBIRD_DATABASE=test.fdb firebird >> /dev/null
docker ps | grep -q firebird
docker stop firebird
docker start firebird >> /dev/null
docker logs firebird
sleep 2
docker ps | grep -q firebird
