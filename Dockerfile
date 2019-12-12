ARG ARCH=amd64
ARG VERSION=0.19.0.1

FROM $ARCH/debian:stable-slim
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ARG ARCH
ARG VERSION

RUN cd /tmp && \
    if [ "${ARCH}" = "amd64" ]; then export TARBALL_ARCH=x86_64-linux-gnu; fi && \
    if [ "${ARCH}" = "arm64v8" ]; then export TARBALL_ARCH=aarch64-linux-gnu; fi && \
    if [ "${ARCH}" = "arm32v7" ]; then export TARBALL_ARCH=arm-linux-gnueabihf; fi && \
    TARBALL="bitcoin-${VERSION}-${TARBALL_ARCH}.tar.gz" && \
    apt-get update && \
    apt-get install -y wget gpg && \
    wget https://bitcoin.org/bin/bitcoin-core-${VERSION}/${TARBALL} && \
    wget https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 && \
    gpg --verify SHA256SUMS.asc && \
    grep $TARBALL SHA256SUMS.asc | sha256sum -c && \
    tar -zxvf $TARBALL --strip-components=1 && \
    mv bin/bitcoind /usr/local/bin/ && \
    mv bin/bitcoin-cli /usr/local/bin/ && \
    apt-get purge -y wget gpg && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /data
VOLUME /data/.bitcoin

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["bitcoind"]
