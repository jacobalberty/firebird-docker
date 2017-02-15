FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV PREFIX=/usr/local/firebird
ENV DEBIAN_FRONTEND noninteractive
ENV FBURL=http://downloads.sourceforge.net/project/firebird/firebird/2.5.6-Release/Firebird-2.5.6.27020-0.tar.bz2
ENV DBPATH=/databases

RUN apt-get update && \
    apt-get install -qy --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        g++ \
        gcc \
        libicu52 \
        libicu-dev \
        libncurses5-dev \
        make && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -o firebird-source.tar.bz2 -L \
        "${FBURL}" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure \
        --prefix=${PREFIX} --with-fbbin=${PREFIX}/bin --with-fbsbin=${PREFIX}/bin --with-fblib=${PREFIX}/lib \
        --with-fbinclude=${PREFIX}/include --with-fbdoc=${PREFIX}/doc --with-fbudf=${PREFIX}/UDF \
        --with-fbsample=${PREFIX}/examples --with-fbsample-db=${PREFIX}/examples/empbuild --with-fbhelp=${PREFIX}/help \
        --with-fbintl=${PREFIX}/intl --with-fbmisc=${PREFIX}/misc --with-fbplugins=${PREFIX} \
        --with-fblog=/var/firebird/log --with-fbglock=/var/firebird/run \
        --with-fbconf=/var/firebird/etc --with-fbmsg=${PREFIX} \
        --with-fbsecure-db=/var/firebird/system --with-system-icu &&\
    make && \
    make silent_install && \
    cd / && \
    rm -rf /home/firebird && \
    find ${PREFIX} -name .debug -prune -exec rm -rf {} \; && \
    apt-get purge -qy --auto-remove \
        libncurses5-dev \
        bzip2 \
        ca-certificates \
        curl \
        gcc \
        g++ \
        make \
        libicu-dev && \
    rm -rf /var/lib/apt/lists/* && \
    mv /var/firebird/system/security2.fdb ${PREFIX}/security2.fdb


VOLUME ["/databases", "/var/firebird/run", "/var/firebird/etc", "/var/firebird/log", "/var/firebird/system", "/tmp/firebird"]

EXPOSE 3050/tcp

ADD docker-entrypoint.sh ${PREFIX}/docker-entrypoint.sh
RUN chmod +x ${PREFIX}/docker-entrypoint.sh

ENTRYPOINT ${PREFIX}/docker-entrypoint.sh ${PREFIX}/bin/fbguard
