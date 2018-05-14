FROM ubuntu:18.04

LABEL description="Fluent Bit Docker image" \
      vendor="Samsung CNCT" \
      maintainer="Jim Conner <snafu.x@gmail.com>"

ENV FLB_MAJOR 0
ENV FLB_MINOR 13
ENV FLB_PATCH 1
ENV FLB_VERSION $FLB_MAJOR.$FLB_MINOR.$FLB_PATCH

ENV FLB_TARBALL http://github.com/fluent/fluent-bit/archive/v$FLB_VERSION.zip

RUN mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log \
    && apt-get -qq update \
    && apt-get -qq clean \
    && apt-get install -y -qq \
       build-essential \
       cmake \
       make \
       wget \
       unzip \
       libsystemd-dev \
    && wget -O "/tmp/fluent-bit-${FLB_VERSION}.zip" ${FLB_TARBALL} \
    && cd /tmp && unzip "fluent-bit-$FLB_VERSION.zip" \
    && cd "fluent-bit-$FLB_VERSION"/build/ \
    && cmake -DFLB_DEBUG=On -DFLB_TRACE=On -DFLB_JEMALLOC=On -DFLB_BUFFERING=On ../ \
    && make \
    && install bin/fluent-bit /fluent-bit/bin/ \
    && apt-get remove --purge --auto-remove -y -qq \
       build-essential \
       cmake \
       make \
       wget \
       unzip \
       libsystemd-dev \
       bzip2 \
       openssl \
       manpages \
    && apt-get install -y -qq --no-install-recommends ca-certificates \
    && apt-get -qq clean \
    && rm -rf /tmp/*

# Configuration files
COPY fluent-bit.conf /fluent-bit/etc/
COPY parsers.conf /fluent-bit/etc/

# Entry point
CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]
