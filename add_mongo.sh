#!/bin/sh

VERSION=$1
PORT=$2

DATA_DIR=$HOME/mongo/$VERSION
mkdir -p $DATA_DIR

docker run --name mongo-$VERSION --restart=always --user "$(id -u):$(id -g)" --security-opt seccomp=unconfined -v $DATA_DIR:/data/db -p $PORT:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=password -d mongo:$VERSION

