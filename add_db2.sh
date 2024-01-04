#!/bin/sh

VERSION=$1
PORT=$2

DATA_DIR=$HOME/db2/$VERSION
mkdir -p $DATA_DIR

docker create --restart=always --name db2-$VERSION --privileged=true -p $PORT:50000 -e LICENSE=accept -e DB2INST1_PASSWORD=password -e DBNAME=db2 -v $DATA_DIR:/database ibmcom/db2:$VERSION
docker start db2-$VERSION

