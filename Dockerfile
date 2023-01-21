ARG ARCH="amd64"
ARG VERSION="0.19.1"

ARG LEGACY_BITCOIN_CORE_RELEASE_KEY="01EA5486DE18A882D4C2684590C8019E36C2E964"
ARG ANDREW_CHOW="152812300785C96444D3334D17565732E08E5E41"
ARG JON_ATACK="82921A4B88FD454B7EB8CE3C796C4109063D4EAF"
ARG JONAS_SCHNELLI="32EE5C4C3FA15CCADB46ABE529D4BCB6416F53EC"
ARG MATT_CORALLO="07DF3E57A548CCFB7530709189BBB8663E2E65CE"
ARG LUKE_DASHJR="E463A93F5F3117EEDE6C7316BD02942421F4889F"
ARG PETER_TODD="37EC7D7B0A217CDB4B4E007E7FAB114267E4FA04"
ARG PIETER_WUILLE="133EAC179436F14A5CF1B794860FEB804E669320"
ARG SJORS_PROVOOST="ED9BDF7AD6A55E232E84524257FF9BDBCC301009"
ARG KEYS="${LEGACY_BITCOIN_CORE_RELEASE_KEY} ${ANDREW_CHOW} ${JON_ATACK} ${JONAS_SCHNELLI} ${MATT_CORALLO} ${LUKE_DASHJR} ${PETER_TODD} ${PIETER_WUILLE} ${SJORS_PROVOOST}"

FROM $ARCH/debian:stable-slim
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ARG ARCH
ARG VERSION
ARG KEYS

RUN cd /tmp && \
    if [ "${ARCH}" = "amd64" ]; then TARBALL_ARCH=x86_64-linux-gnu; fi && \
    if [ "${ARCH}" = "arm64v8" ]; then TARBALL_ARCH=aarch64-linux-gnu; fi && \
    if [ "${ARCH}" = "arm32v7" ]; then TARBALL_ARCH=arm-linux-gnueabihf; fi && \
    TARBALL="bitcoin-${VERSION}-${TARBALL_ARCH}.tar.gz" && \
    apt-get update && \
    apt-get install -y wget gpg && \
    wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/${TARBALL} && \
    # This file only exists after v22
    wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS || true && \
    wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys $KEYS && \
    gpg --verify SHA256SUMS.asc 2>&1 >/dev/null | grep "^gpg: Good signature from" || { echo "No valid signature"; exit 1; } && \
    if [ -f SHA256SUMS ]; then CHECKSUM_FILE="SHA256SUMS"; else CHECKSUM_FILE="SHA256SUMS.asc"; fi && \
    grep $TARBALL $CHECKSUM_FILE | sha256sum -c && \
    # sha256sum -c --ignore-missing "${CHECKSUM_FILE}" \
    tar -zxvf $TARBALL --strip-components=1 && \
    mv bin/bitcoind /usr/local/bin/ && \
    mv bin/bitcoin-cli /usr/local/bin/ && \
    apt-get purge -y wget gpg && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /data
VOLUME /data/.bitcoin

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["bitcoind"]
