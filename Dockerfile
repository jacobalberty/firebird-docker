FROM debian:bullseye
LABEL maintainer="jacob.alberty@foundigital.com"

ENV PREFIX=/usr/local/firebird
ENV VOLUME=/firebird
ENV DEBIAN_FRONTEND noninteractive
ENV FBURL=https://github.com/FirebirdSQL/firebird/releases/download/R2_5_9/Firebird-2.5.9.27139-0.tar.bz2
ENV DBPATH=/firebird/data
ENV ICU_URL=https://github.com/unicode-org/icu/releases/download/release-52-2/icu4c-52_2-src.tgz

RUN apt-get update && \
    apt-get install -qy --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        g++ \
        gcc \
        libncurses5-dev \
        make && \
        mkdir -p /home/icu && \
        cd /home/icu && \
        curl -L -o icu4c.tar.gz -L "${ICU_URL}" && \
        tar --strip=1 -xf icu4c.tar.gz && \
        cd source && \
        ./configure --prefix=/usr && \
        make -j$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo) && \
        make install && \
        cd / && \
        rm -rf /home/icu && \
    mkdir -p /home/firebird && \
    cd /home/firebird && \
    curl -L -o firebird-source.tar.bz2 -L \
        "${FBURL}" && \
    tar --strip=1 -xf firebird-source.tar.bz2 && \
    ./configure \
        --prefix=${PREFIX} --with-fbbin=${PREFIX}/bin --with-fbsbin=${PREFIX}/bin --with-fblib=${PREFIX}/lib \
        --with-fbinclude=${PREFIX}/include --with-fbdoc=${PREFIX}/doc --with-fbudf=${PREFIX}/UDF \
        --with-fbsample=${PREFIX}/examples --with-fbsample-db=${PREFIX}/examples/empbuild --with-fbhelp=${PREFIX}/help \
        --with-fbintl=${PREFIX}/intl --with-fbmisc=${PREFIX}/misc --with-fbplugins=${PREFIX} \
        --with-fblog=${VOLUME}/log --with-fbglock=/var/firebird/run \
        --with-fbconf=${VOLUME}/etc --with-fbmsg=${PREFIX} \
        --with-fbsecure-db=${VOLUME}/system --with-system-icu &&\
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
        make && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p "${PREFIX}/skel" && \
    mv ${VOLUME}/system/security2.fdb ${PREFIX}/skel/security2.fdb && \
    mv "${VOLUME}/etc" "${PREFIX}/skel"


VOLUME ["/firebird"]

EXPOSE 3050/tcp

COPY docker-entrypoint.sh ${PREFIX}/docker-entrypoint.sh
RUN chmod +x ${PREFIX}/docker-entrypoint.sh

COPY docker-healthcheck.sh ${PREFIX}/docker-healthcheck.sh
RUN chmod +x ${PREFIX}/docker-healthcheck.sh \
    && apt-get update \
    && apt-get -qy install netcat \
    && rm -rf /var/lib/apt/lists/*
HEALTHCHECK CMD ${PREFIX}/docker-healthcheck.sh || exit 1

ENTRYPOINT ["/usr/local/firebird/docker-entrypoint.sh"]

CMD ["/usr/local/firebird/bin/fbguard"]

