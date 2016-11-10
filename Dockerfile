FROM debian:jessie
MAINTAINER Joakim Karlsson <jk@patientsky.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti' > /etc/apt/sources.list.d/unifi.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50

RUN apt-get update -y && apt-get install -y \
curl \
haveged \
unifi \
&& rm -rf /var/lib/apt/lists/*

ADD unifi_start.sh /opt/

EXPOSE 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

WORKDIR /var/lib/unifi

ENTRYPOINT ["/opt/unifi_start.sh"]
CMD ["start"]