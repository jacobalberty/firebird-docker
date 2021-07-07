#!/bin/bash
# This updates config.guess to solve unable to guess system type.
GUESSURL="https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=45e181800a6a27268a9c5d79dcc60492fef9a9a0"

curl -L -o /home/firebird/builds/make.new/config/config.guess -L \
    "${GUESSURL}"

