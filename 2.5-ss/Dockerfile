FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV PREFIX=/usr/local/firebird
ENV DEBIAN_FRONTEND noninteractive

ADD ./setPass.sh /home/setPass.sh

RUN apt-get update && \
    apt-get install -qy libncurses5-dev bzip2 curl gcc g++ make libicu-dev libicu52 && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -o firebird-source.tar.bz2 -L \
        "http://downloads.sourceforge.net/project/firebird/firebird/2.5.5-Release/Firebird-2.5.5.26952-0.tar.bz2" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure --enable-superserver \
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
    rm -rf ${PREFIX}/*/.debug && \
    apt-get purge -qy --auto-remove libncurses5-dev bzip2 curl gcc g++ make libicu-dev && \
    apt-get clean -q && \
    rm -rf /var/lib/apt/lists/* && \
    /home/setPass.sh && \
    rm -f /home/setPass.sh


EXPOSE 3050/tcp

ENTRYPOINT ["/usr/local/firebird/bin/fbguard"]
