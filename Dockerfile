FROM ghcr.io/nforceroh/k8s-alpine-baseimage:3.23

ARG \
  BUILD_DATE=unknown \
  VERSION=unknown

LABEL \
  org.label-schema.maintainer="Sylvain Martin (sylvain@nforcer.com)" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.vcs-url="https://github.com/nforcer/k8s-postfix" \
  org.label-schema.schema-version="1.0"


### Install Dependencies
RUN \
  echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
  && apk add --no-cache py3-pip redis \
  && pip install --upgrade pyzor --break-system-packages \
  && pip install --upgrade redis --break-system-packages \
  && addgroup pyzor 2>/dev/null \
  && adduser -D --gecos "pyzor antispam" --ingroup pyzor pyzor 2>/dev/null \
  && mkdir /home/pyzor/.pyzor && chown pyzor:pyzor /home/pyzor/.pyzor \
  && rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD --chmod=755 /content/etc/s6-overlay /etc/s6-overlay
ADD --chown=pyzor:pyzor --chmod=644 /content/conf/* /home/pyzor/.pyzor
ADD --chmod=755 /content/usr/local/bin/* /usr/local/bin/

EXPOSE 24441

ENTRYPOINT [ "/init" ]
