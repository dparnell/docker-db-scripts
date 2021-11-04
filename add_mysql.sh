#!/bin/sh

VERSION=$1
PORT=$2

DATA_DIR=$HOME/mysqldata/$VERSION
mkdir -p $DATA_DIR

docker run --name mysql-$VERSION --restart=always --user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro -v $DATA_DIR:/var/lib/mysql -p $PORT:3306 -e MYSQL_ROOT_PASSWORD=password -d mysql:$VERSION

