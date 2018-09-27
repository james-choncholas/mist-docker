#!/bin/bash

set -e

sudo docker build \
    -t mist:11.1 \
    .
