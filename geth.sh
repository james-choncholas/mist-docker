#!/bin/bash

# Starts geth with RPC enabled and opens the port to
# any incomming connections. Meant to be run on a
# central server while mist  clients (local or remote)
# connect to this containers RPC server.

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
ETHCHAINPATH=/mnt/speeddrive/ethereum


# stop old container
if [ "$(sudo docker ps -q -f name=geth)" ]; then
    echo "cleaning up geth container"
    sudo docker stop geth -t0
    sudo docker rm geth
fi

# Start geth making the RPC port accessible to the network
sudo docker run -d --rm \
    --name geth \
    -p 30303:30303 \
    -p 8546:8546 \
    -v $ETHCHAINPATH:/root/.ethereum \
    ethereum/client-go \
        --syncmode "fast" \
        --rpc \
        --rpcaddr 0.0.0.0 \
        --rpcport 8545 \
        --rpccorsdomain 0.0.0.0 \
        --rpcapi "eth,web3,miner,net,admin,personal,debug" \
        --ws \
        --wsaddr 0.0.0.0 \
        --wsport 8546 \
        --wsorigins "*" \
        --ipcdisable

# Flags to enable the websocked RPC server
#--ws Enable the WS-RPC server
#--wsaddr WS-RPC server listening interface (default: "localhost")
#--wsport WS-RPC server listening port (default: 8546)
#--wsapi API's offered over the WS-RPC interface (default: "eth,net,web3")
#--wsorigins Origins from which to accept websockets requests
#--rpccorsdomain turns on "cross-origin resource sharing" to allow webpages
# served by the listed domain to access the rpc interface. If a simple status
# page is served by the same machine, allow it access

# state trie dstabase cache size
#--cache=1024 \
#--memory 3g \
#--memory-swap 3g \

# test rpc with:
#curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://localhost:8545
