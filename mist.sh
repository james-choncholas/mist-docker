#!/bin/bash

# Starts the mist container and tries to connect to $SERVER's
# RPC port 8545.

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SERVER=192.168.1.4

# stop old container
if [ "$(sudo docker ps -q -f name=mist)" ]; then
    echo "cleaning up mist container"
    sudo docker stop mist -t0
    sudo docker rm $(sudo docker ps --filter=status=exited --filter=status=created -q)
fi

if [ "$(sudo docker ps -q -f name=geth)" ]; then
    echo "geth is running on this machine"
    # Note if mist is running on the same machine as geth RPC server,
    # the RPC port (8545) has been taken by geth. Map around it with
    # port 8540.
    PORTMAP="-p 8540:8545"
    SERVER=$(hostname -I | awk '{print $1}')
else
    # port 8545 must be opened for the RPC interface
    PORTMAP="-p 8545:8545"
fi

xhost local:root

sudo docker run -it --rm \
    --name mist \
    $PORTMAP \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v /home/$USER/Downloads/mist:/root/Downloads \
    -v /usr/share/themes:/usr/share/themes:ro \
    -v /usr/share/fonts:/usr/share/fonts:ro \
    -v $SCRIPTPATH/.themes:/root/.themes:ro \
    -v $SCRIPTPATH/.fonts:/root/.fonts:ro \
    -v $SCRIPTPATH/.icons:/root/.icons:ro \
    -v $SCRIPTPATH/.ethereum:/root/.ethereum \
    -v $SCRIPTPATH/.config/:/root/.config \
    -v $SCRIPTPATH/contracts/:/root/contracts \
    --shm-size 2g \
    mist:10.0 \
        --skiptimesynccheck \
        --rpc http://$SERVER:8545

#docker args
    #-v $SCRIPTPATH/.gtkrc-2.0:/root/mist/.gtkrc-2.0:ro \
#application args
        #--swarmurl null
