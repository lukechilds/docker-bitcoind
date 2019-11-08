
# docker-bitcoind

[![Build Status](https://travis-ci.org/lukechilds/docker-bitcoind.svg?branch=master)](https://travis-ci.org/lukechilds/docker-bitcoind)
[![Image Layers](https://images.microbadger.com/badges/image/lukechilds/bitcoind.svg)](https://microbadger.com/images/lukechilds/bitcoind)
[![Docker Pulls](https://img.shields.io/docker/pulls/lukechilds/bitcoind.svg)](https://hub.docker.com/r/lukechilds/bitcoind/)

> Run a full Bitcoin node with one command

A Docker configuration with sane defaults for running a full
Bitcoin node.

## Usage

```
docker run -v /home/username/bitcoin:/data -p 8333:8333 lukechilds/bitcoind
```

If there's a `bitcoin.conf` in the `/data` volume it'll be used. If not, one will be created for you with a randomly generated JSON-RPC password.

### JSON-RPC

To access JSON-RPC you'll also need to expose port 8332. You probably only want this available to localhost:

```
docker run -v /home/username/bitcoin:/data -p 8333:8333 -p 127.0.0.1:8332:8332 lukechilds/bitcoind
```

### CLI Arguments

All CLI arguments are passed directly through to bitcoind.

You can use this to configure via CLI args without a config file:

```
docker run -v /home/username/bitcoin:/data \
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

You can also run a specific version of bitcoind if you want.

```
docker run -v /home/username/bitcoin:/data -p 8333:8333 lukechilds/bitcoind:v0.11.1.0
```

## License

MIT © Luke Childs
