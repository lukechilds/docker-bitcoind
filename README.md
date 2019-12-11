# docker-bitcoind

[![Image Layers](https://images.microbadger.com/badges/image/lukechilds/bitcoind.svg)](https://microbadger.com/images/lukechilds/bitcoind)
[![Docker Pulls](https://img.shields.io/docker/pulls/lukechilds/bitcoind.svg)](https://hub.docker.com/r/lukechilds/bitcoind/)
[![tippin.me](https://badgen.net/badge/%E2%9A%A1%EF%B8%8Ftippin.me/@lukechilds/F0918E)](https://tippin.me/@lukechilds)

> Run a full Bitcoin node with one command

A Docker configuration with sane defaults for running a full
Bitcoin node.

## Usage

```
docker --name bitcoind run -v $HOME/.bitcoin:/data/.bitcoin -p 8333:8333 lukechilds/bitcoind
```

### JSON-RPC

To query `bitcoind`, execute `bitcoin-cli` from within the container:

```
docker exec -it bitcoind bitcoin-cli getnetworkinfo
```

To access JSON-RPC from other services you'll also need to expose port 8332. You probably only want this available to localhost:

```
docker --name bitcoind run -v $HOME/.bitcoin:/data/.bitcoin -p 8333:8333 -p 127.0.0.1:8332:8332 lukechilds/bitcoind
```

### CLI Arguments

All CLI arguments are passed directly through to bitcoind.

You can use this to configure via CLI args without a config file:

```
docker --name bitcoind run -v $HOME/.bitcoin:/data/.bitcoin \
  -p 8333:8333 \
  -p 127.0.0.1:8332:8332 \
  lukechilds/bitcoind -rpcuser=jonsnow -rpcpassword=ikn0wnothin
```

Or just use the container like a bitcoind binary:

```
$ docker run lukechilds/bitcoind -version
Bitcoin Core Daemon version v0.18.1
Copyright (C) 2009-2019 The Bitcoin Core developers

Please contribute if you find Bitcoin Core useful. Visit
<https://bitcoincore.org> for further information about the software.
The source code is available from <https://github.com/bitcoin/bitcoin>.

This is experimental software.
Distributed under the MIT software license, see the accompanying file COPYING
or <https://opensource.org/licenses/MIT>

This product includes software developed by the OpenSSL Project for use in the
OpenSSL Toolkit <https://www.openssl.org> and cryptographic software written by
Eric Young and UPnP software written by Thomas Bernard.
```

### Version

Run a specific version of bitcoind if you want.

```
docker --name bitcoind run -v $HOME/.bitcoin:/data/.bitcoin -p 8333:8333 lukechilds/bitcoind:v0.18.1
```

## Build

Build this image yourself by checking out this repo, `cd` ing into it and running:

```
docker build -t lukechilds/bitcoind .
```

You can build a specific version by passing in the `VERSION` build arg:

```
docker build --build-arg VERSION=0.18.1 -t lukechilds/bitcoind:v0.18.1 .
```

## License

MIT © Luke Childs
