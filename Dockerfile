FROM debian:stable-slim
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./bin /usr/local/bin
COPY ./VERSION /tmp
COPY ./CHECKSUM /tmp

RUN VERSION=`cat /tmp/VERSION` && \
    chmod a+x /usr/local/bin/* && \
    apt-get update && \
    apt-get install -y curl && \
    curl -L https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz --output /tmp/prebuilt.tar.gz && \
    echo "$(cat /tmp/CHECKSUM)  /tmp/prebuilt.tar.gz" | sha256sum -c && \
    tar -zxvf /tmp/prebuilt.tar.gz -C /tmp && \
    mv /tmp/bitcoin-${VERSION}/bin/* /usr/local/bin/ && \
    apt-get purge -y curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV DATA /data
WORKDIR /data

EXPOSE 8332 8333

ENTRYPOINT ["init"]
