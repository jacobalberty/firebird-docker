FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV PREFIX=/usr/local/firebird
ENV DEBIAN_FRONTEND noninteractive
ENV FBURL=http://downloads.sourceforge.net/project/firebird/firebird/3.0-Beta_2/Firebird-3.0.0.31896-Beta2.tar.bz2

ADD build.sh ./build.sh

RUN ./build.sh && \
    rm -f ./build.sh

VOLUME ["/databases", "/var/firebird/run", "/var/firebird/etc", "/var/firebird/log", "/var/firebird/system", "/tmp/firebird"]

EXPOSE 3050/tcp

ENTRYPOINT ["/usr/local/firebird/bin/fbguard"]
