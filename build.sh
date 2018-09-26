#!/bin/bash

set -e

sudo docker build \
    -t mist:10.0 \
    .
