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

# Build stage
FROM --platform=$BUILDPLATFORM debian:stable-slim as builder
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ARG TARGETARCH

ARG ARCH
ARG VERSION
ARG KEYS

WORKDIR /build

RUN echo "Installing build deps"
RUN apt-get update
RUN apt-get install -y wget pgp

RUN echo "Deriving tarball name from \$TARGETARCH"
RUN [ "${TARGETARCH}" = "amd64" ] && echo "bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz"    > /tarball-name || true
RUN [ "${TARGETARCH}" = "arm64" ] && echo "bitcoin-${VERSION}-aarch64-linux-gnu.tar.gz"   > /tarball-name || true
RUN [ "${TARGETARCH}" = "arm" ]   && echo "bitcoin-${VERSION}-arm-linux-gnueabihf.tar.gz" > /tarball-name || true
RUN echo "Tarball name: $(cat /tarball-name)"

RUN echo "Downloading release assets"
RUN wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/$(cat /tarball-name)
RUN wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc
# This file only exists after v22 so allow it to fail
RUN wget https://bitcoincore.org/bin/bitcoin-core-${VERSION}/SHA256SUMS || true
RUN echo "Downloaded release assets:" && ls

RUN echo "Verifying PGP signatures"
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys $KEYS
RUN gpg --verify SHA256SUMS.asc 2>&1 >/dev/null | grep "^gpg: Good signature from" || { echo "No valid signature"; exit 1; }
RUN echo "PGP signature verification passed"

RUN echo "Verifying checksums"
RUN [ -f SHA256SUMS ] && cp SHA256SUMS /sha256sums || cp SHA256SUMS.asc /sha256sums
RUN grep $(cat /tarball-name) /sha256sums | sha256sum -c
RUN echo "Chucksums verified ok"

RUN echo "Extracting release assets"
RUN tar -zxvf $(cat /tarball-name) --strip-components=1

# Final image
FROM debian:stable-slim

COPY --from=builder /build/bin/bitcoind /bin
COPY --from=builder /build/bin/bitcoin-cli /bin

ENV HOME /data
VOLUME /data/.bitcoin

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["bitcoind"]
