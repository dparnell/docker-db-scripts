#!/bin/sh

VERSION=$1
PORT=$2

DATA_DIR=$HOME/pgdata/$VERSION
mkdir -p $DATA_DIR

docker run --name pg-$VERSION --restart=always --user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro -v $DATA_DIR:/var/lib/postgresql/data -p $PORT:5432 -e POSTGRES_PASSWORD=password -d postgres:$VERSION

