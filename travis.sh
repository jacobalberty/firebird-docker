#!/bin/bash
set -e
docker run -d -p 127.0.0.1:3050:3050 --name firebird firebird
docker ps | grep -q firebird
docker rm -f -v firebird
docker run -d --name firebird -e FIREBIRD_USER=testing -e FIREBIRD_DATABASE=test.fdb firebird
docker ps | grep -q firebird
docker stop firebird
docker start firebird
docker ps | grep -q firebird

