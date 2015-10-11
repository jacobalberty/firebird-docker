FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV PREFIX=/usr/local/firebird
ENV DEBIAN_FRONTEND noninteractive
ENV FBURL=http://downloads.sourceforge.net/project/firebird/firebird/3.0-Beta_2/Firebird-3.0.0.31896-Beta2.tar.bz2

RUN apt-get update && \
    apt-get install -qy curl bzip2 gcc zlib1g-dev libicu-dev libtommath-dev libncurses5-dev make g++ libicu52 libtommath0 && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -o firebird-source.tar.bz2 -L \
        "${FBURL}" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure \
        --prefix=${PREFIX}/ --with-fbbin=${PREFIX}/bin/ --with-fbsbin=${PREFIX}/bin/ --with-fblib=${PREFIX}/lib/ \
        --with-fbinclude=${PREFIX}/include/ --with-fbdoc=${PREFIX}/doc/ --with-fbudf=${PREFIX}/UDF/ \
        --with-fbsample=${PREFIX}/examples/ --with-fbsample-db=${PREFIX}/examples/empbuild/ --with-fbhelp=${PREFIX}/help/ \
        --with-fbintl=${PREFIX}/intl/ --with-fbmisc=${PREFIX}/misc/ --with-fbplugins=${PREFIX}/ \
        --with-fbconf=/var/firebird/etc/ --with-fbmsg=${PREFIX}/ \
        --with-fblog=/var/firebird/log/ --with-fbglock=/var/firebird/run/ \
        --with-fbsecure-db=/var/firebird/system && \
    make && \
    make silent_install && \
    cd / && \
    rm -rf /home/firebird && \
    rm -rf ${PREFIX}/*/.debug && \
    apt-get purge -qy --auto-remove curl bzip2 gcc zlib1g-dev libicu-dev libtommath-dev libncurses5-dev make g++ && \
    apt-get clean -q && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/databases", "/var/firebird/run", "/var/firebird/etc", "/var/firebird/log", "/var/firebird/system", "/tmp/firebird"]

EXPOSE 3050/tcp

ENTRYPOINT ["/usr/local/firebird/bin/fbguard"]
