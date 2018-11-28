## builder
#
FROM debian:stable-slim as builder

ENV FLB_MAJOR 0
ENV FLB_MINOR 14
ENV FLB_PATCH 8
ENV FLB_VERSION ${FLB_MAJOR}.${FLB_MINOR}.${FLB_PATCH}

ENV DEBIAN_FRONTEND noninteractive

ENV FLB_TARBALL http://github.com/fluent/fluent-bit/archive/v$FLB_VERSION.zip

RUN mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log /tmp/src/ \
  && apt-get update \
  && apt-get install -y \
  build-essential \
  cmake \
  make \
  wget \
  unzip \
  libsystemd-dev \
  libssl1.0-dev \
  libasl-dev \
  && wget -O "/tmp/fluent-bit-${FLB_VERSION}.zip" ${FLB_TARBALL} \
  && cd /tmp && unzip "fluent-bit-$FLB_VERSION.zip" \
  && cd "fluent-bit-$FLB_VERSION"/build/ \
  && cmake -DFLB_DEBUG=On \
  -DFLB_TRACE=Off \
  -DFLB_JEMALLOC=On \
  -DFLB_BUFFERING=On \
  -DFLB_TLS=On \
  -DFLB_WITHOUT_SHARED_LIB=On \
  -DFLB_WITHOUT_EXAMPLES=On \
  -DFLB_HTTP_SERVER=On \
  -DFLB_OUT_KAFKA=On .. \
  && make \
  && install bin/fluent-bit /fluent-bit/bin/

COPY fluent-bit.conf parsers.conf /fluent-bit/etc/

## worker
#
FROM debian:stable-slim
LABEL MAINTAINER "OSS Maintainers <oss-maintainer@samsung-cnct.io"> \
  Description="Fluent Bit docker image"

RUN apt-get update \
  && apt-get install --no-install-recommends ca-certificates libssl1.0.2 -y \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/* /var/lib/dpkg/* /var/log/* /var/cache/*

COPY --from=builder /fluent-bit /fluent-bit

EXPOSE 2020
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]
