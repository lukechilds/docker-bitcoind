FROM debian:stable-slim
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./bin /usr/local/bin
COPY ./VERSION /tmp
COPY ./CHECKSUM /tmp

RUN VERSION=`cat /tmp/VERSION` && \
    TARBALL="bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz" && \
    chmod a+x /usr/local/bin/* && \
    apt-get update && \
    apt-get install -y curl && \
    cd /tmp && \
    curl -O https://bitcoin.org/bin/bitcoin-core-${VERSION}/${TARBALL} && \
    echo "$(cat /tmp/CHECKSUM) $TARBALL" | sha256sum -c && \
    tar -zxvf $TARBALL && \
    mv bitcoin-${VERSION}/bin/* /usr/local/bin/ && \
    apt-get purge -y curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV DATA /data
WORKDIR /data

EXPOSE 8332 8333

ENTRYPOINT ["init"]
