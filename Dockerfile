FROM debian:jessie

#Based on the work of Jacob Alberty <jacob.alberty@foundigital.com>
MAINTAINER Joakim Karlsson <jk@patientsky.com>

ENV DEBIAN_FRONTEND=noninteractive \
  BASEDIR=/usr/lib/unifi \
  DATADIR=/var/lib/unifi \
  RUNDIR=/var/run/unifi \
  LOGDIR=/var/log/unifi \
  JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
  JVM_MAX_HEAP_SIZE=4096M \
  JVM_INIT_HEAP_SIZE=

RUN echo 'deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti' > /etc/apt/sources.list.d/unifi.list \
	&& echo "deb http://deb.debian.org/debian/ jessie-backports main" > /etc/apt/sources.list.d/backports.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50

RUN apt-get clean -y \
	&& apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -t jessie-backports -y --no-install-recommends \
    	ca-certificates-java \
    	openjdk-8-jre-headless \
    	prelink \
    	unifi \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

ADD 'https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb' /tmp/dumb-init_1.2.0_amd64.deb
RUN dpkg -i /tmp/dumb-init_*.deb \
	&& rm /tmp/dumb-init_*.deb

RUN execstack -c /usr/lib/unifi/lib/native/Linux/amd64/libubnt_webrtc_jni.so

COPY unifi.sh /opt/
RUN chmod a+x /opt/unifi.sh

RUN ln -s ${BASEDIR}/data ${DATADIR} && \
  ln -s ${BASEDIR}/run ${RUNDIR} && \
  ln -s ${BASEDIR}/logs ${LOGDIR}

VOLUME ["${DATADIR}", "${RUNDIR}", "${LOGDIR}"]
# not sure if "/usr/lib/unifi/work" is needed as well?

EXPOSE 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp 6789/tcp

WORKDIR /var/lib/unifi


ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/unifi.sh"]
