# docker-bitcoind

[![Actions Status](https://badgen.net/github/checks/lukechilds/docker-bitcoind?icon=github&label=Build%20Status)](https://github.com/lukechilds/docker-bitcoind/actions)
[![Docker Pulls](https://badgen.net/docker/pulls/lukechilds/bitcoind?icon=docker&label=Docker%20pulls)](https://hub.docker.com/r/lukechilds/bitcoind/)
[![Docker Image Size](https://badgen.net/docker/size/lukechilds/bitcoind/latest/amd64?icon=docker&label=lukechilds/bitcoind)](https://hub.docker.com/r/lukechilds/bitcoind/tags?name=latest)
[![GitHub Donate](https://badgen.net/badge/GitHub/Sponsor/D959A7?icon=github)](https://github.com/sponsors/lukechilds)
[![Bitcoin Donate](https://badgen.net/badge/Bitcoin/Donate/F19537?icon=bitcoin)](https://blockstream.info/address/3Luke2qRn5iLj4NiFrvLBu2jaEj7JeMR6w)
[![Lightning Donate](https://badgen.net/badge/Lightning/Donate/F6BC41?icon=bitcoin-lightning)](https://tippin.me/@lukechilds?refurl=github.com/lukechilds/docker-bitcoind)

> Run a full Bitcoin node with one command

A Docker configuration with sane defaults for running a full Bitcoin node.

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
docker --name bitcoind run -v $HOME/.bitcoin:/data/.bitcoin \
  -p 8333:8333 \
  -p 127.0.0.1:8332:8332 \
  lukechilds/bitcoind
```

You could now query JSON-RPC via cURL like so:

```
curl --data '{"jsonrpc":"1.0","id":"curltext","method":"getnetworkinfo"}' \
  http://$(cat $HOME/.bitcoin/.cookie)@127.0.0.1:8332
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

You can build a specific architecture by passing in the `ARCH` build arg:

```
docker build --build-arg ARCH=amd64 -t lukechilds/bitcoind:amd64 .
```

For a full list of supported build arg options, check out the [build script matrix](https://github.com/lukechilds/docker-bitcoind/blob/master/.github/workflows/build.yml).

## License

MIT © Luke Childs
