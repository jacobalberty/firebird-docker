FROM debian:jessie
MAINTAINER Jacob Alberty <jacob.alberty@foundigital.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -qy --force-yes firebird2.5-superclassic=2.5.3.26778.ds4-5 && apt-get clean

RUN sed -i -e '/RemoteBindAddress =/ s/= .*/= /' /etc/firebird/2.5/firebird.conf 

ADD setup.sh /setup.sh

RUN chmod u+x /setup.sh
RUN /setup.sh

VOLUME ["/etc/firebird/2.5/", "/var/lib/firebird/2.5/data/"]

EXPOSE 3050/tcp

ENTRYPOINT ["/usr/sbin/fbguard"]
