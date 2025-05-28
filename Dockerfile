FROM docker.io/nforceroh/k8s-alpine-baseimage:latest

ARG \
  BUILD_DATE=now \
  VERSION=unknown

LABEL \
  maintainer="Sylvain Martin (sylvain@nforcer.com)"

ENV \
  RAZORFY_DEBUG=0 \
  RAZORFY_MAXTHREADS=200 \
  RAZORFY_BINDADDRESS=127.0.0.1 \
  RAZORFY_BINDPORT=11342 

### Install Dependencies
RUN apk upgrade --no-cache \
  && apk add --no-cache razor perl-io-socket-ip \
  && rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD rootfs /
ADD https://raw.githubusercontent.com/HeinleinSupport/razorfy/refs/heads/master/razorfy.pl /app/razorfy.pl
ADD https://raw.githubusercontent.com/HeinleinSupport/razorfy/refs/heads/master/razorfy.conf /app/razorfy.conf


RUN find /etc/s6-overlay/s6-rc.d -name run -exec chmod 755 {} \; \
  && chmod 755 /etc/cont-init.d/* \
  && chmod 755 /app/razorfy.pl \
  && chmod 644 /app/razorfy.conf

EXPOSE 11342

ENTRYPOINT [ "/init" ]
