FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV PREFIX=/usr/local/firebird
ENV VOLUME=/firebird
ENV DEBIAN_FRONTEND noninteractive
ENV FBURL=http://downloads.sourceforge.net/project/firebird/firebird/3.0.2-Release/Firebird-3.0.2.32703-0.tar.bz2
ENV DBPATH=/firebird/data

ADD build.sh ./build.sh

RUN chmod +x ./build.sh && \
    sync && \
    ./build.sh && \
    rm -f ./build.sh

VOLUME ["/firebird"]

EXPOSE 3050/tcp

ADD docker-entrypoint.sh ${PREFIX}/docker-entrypoint.sh
RUN chmod +x ${PREFIX}/docker-entrypoint.sh

ENTRYPOINT ${PREFIX}/docker-entrypoint.sh ${PREFIX}/bin/fbguard
