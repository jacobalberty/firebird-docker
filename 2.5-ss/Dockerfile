FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -qy libncurses5-dev bzip2 curl gcc g++ make && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -o firebird-source.tar.bz2 -L \
        "http://downloads.sourceforge.net/project/firebird/firebird/2.5.4-Release/Firebird-2.5.4.26856-0.tar.bz2" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure --enable-superserver --prefix=/usr/local/firebird && \
    make && \
    make silent_install && \
    cd / && \
    rm -rf /home/firebird && \
    rm -rf /usr/local/firebird/*/.debug && \
    apt-get purge -qy --auto-remove libncurses5-dev bzip2 curl gcc g++ make  && \
    apt-get clean -q && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/databases"]

EXPOSE 3050/tcp

ENTRYPOINT ["/usr/local/firebird/bin/fbguard"]
