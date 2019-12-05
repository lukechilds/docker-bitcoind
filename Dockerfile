FROM debian:stable-slim
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./VERSION /tmp

RUN cd /tmp && \
    VERSION=`cat VERSION` && \
    TARBALL="bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz" && \
    apt-get update && \
    apt-get install -y curl gpg && \
    curl -O https://bitcoin.org/bin/bitcoin-core-${VERSION}/${TARBALL} && \
    curl -O https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 && \
    gpg --verify SHA256SUMS.asc && \
    grep $TARBALL SHA256SUMS.asc | sha256sum -c && \
    tar -zxvf $TARBALL && \
    mv bitcoin-${VERSION}/bin/bitcoind /usr/local/bin/ && \
    mv bitcoin-${VERSION}/bin/bitcoin-cli /usr/local/bin/ && \
    apt-get purge -y curl gpg && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /data
VOLUME /data/.bitcoin

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["bitcoind"]
