#!/bin/bash

# Starts geth with RPC enabled and opens the port to
# any incomming connections. Meant to be run on a
# central server while mist  clients (local or remote)
# connect to this containers RPC server.

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
ETHCHAINPATH=$HOME/ethereum-chain


# stop old container
if [ "$(sudo docker ps -q -f name=geth)" ]; then
    echo "cleaning up geth container"
    sudo docker stop geth -t0
    sudo docker rm $(sudo docker ps --filter=status=exited --filter=status=created -q)
fi

# Start geth making the RPC port accessible to the network
sudo docker run -d --rm \
    --name geth \
    -p 30303:30303 \
    -p 8545:8545 \
    -v $ETHCHAINPATH:/root/.ethereum \
    ethereum/client-go \
        --syncmode "full" \
        --rpc \
        --rpcaddr 0.0.0.0 \
        --rpcport 8545 \
        --rpccorsdomain 0.0.0.0 \
        --rpcapi "eth,web3,miner,net,admin,personal,debug" \
        --ipcdisable


# Flags to enable the websocked RPC server. I dont think this is necessary
#--ws Enable the WS-RPC server
#--wsaddr WS-RPC server listening interface (default: "localhost")
#--wsport WS-RPC server listening port (default: 8546)
#--wsapi API's offered over the WS-RPC interface (default: "eth,net,web3")
#--wsorigins Origins from which to accept websockets requests

# test rpc with:
#curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://localhost:8545
