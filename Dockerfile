FROM ghcr.io/nforceroh/k8s-alpine-baseimage:3.23

ARG \
  BUILD_DATE=unknown \
  VERSION=unknown

ENV \
  VERSION=1.0.0 \
  SERVICE=pyzor-cc \
  REDIS_SERVER=redis.k3s.nf.lab \
  REDIS_PORT=6379 \
  REDIS_DB=5 \
  REDIS_PASSWORD="" \
  PYZOR_SERVER=0.0.0.0 \
  PYZOR_PORT=24441 \
  LOGS_DIR=/data/logs

LABEL \
  org.label-schema.maintainer="Sylvain Martin (sylvain@nforcer.com)" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.vcs-url="https://github.com/nforcer/k8s-pyzor" \
  org.label-schema.schema-version="1.0"

### Install Dependencies
RUN \
  echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
  && apk add --no-cache python3 \
    py3-pip \
    bash \
    curl \
    xz \
    py3-pyzor py3-redis \
  && addgroup pyzor 2>/dev/null \
  && adduser -D --gecos "pyzor antispam" --ingroup pyzor pyzor 2>/dev/null \
  && mkdir /home/pyzor/.pyzor && chown pyzor:pyzor /home/pyzor/.pyzor

### Add Files
ADD --chmod=755 /content/etc/s6-overlay /etc/s6-overlay
ADD --chown=pyzor:pyzor --chmod=644 /content/conf/* /home/pyzor/.pyzor
ADD --chmod=755 /content/usr/local/bin/* /usr/local/bin/

EXPOSE ${PYZOR_PORT}

ENTRYPOINT [ "/init" ]
