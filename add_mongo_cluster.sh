#!/bin/bash -e

VERSION=$1
PORT_1=$2
PORT_2=$3
PORT_3=$4

BASE_DIR=$HOME/mongo-cluster/$VERSION
DATA_DIR=$BASE_DIR/data
CONF_DIR=$BASE_DIR/config
mkdir -p $DATA_DIR/node1
mkdir -p $DATA_DIR/node2
mkdir -p $DATA_DIR/node3
mkdir -p $CONF_DIR

openssl rand -base64 768 > $CONF_DIR/mongo-repl.key
chmod 600 $CONF_DIR/mongo-repl.key

echo Creating mongo $VERSION network...
docker network create -d bridge mongo-$VERSION

echo Starting 3 mongo nodes...

docker run --name mongo-cluster-$VERSION-1 --restart=always --user "$(id -u):$(id -g)" \
	-v $DATA_DIR/node1:/data/db \
	-v $CONF_DIR/mongo-repl.key:/etc/mongo-repl.key \
	--network mongo-$VERSION \
	--hostname mongo1 \
	--net-alias mongo1 \
	-p $PORT_1:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=password \
	-d mongo:$VERSION \
	mongod --serviceExecutor adaptive --replSet rs1 --port 27017 --keyFile /etc/mongo-repl.key

docker run --name mongo-cluster-$VERSION-2 --restart=always --user "$(id -u):$(id -g)" \
	-v $DATA_DIR/node2:/data/db \
	-v $CONF_DIR/mongo-repl.key:/etc/mongo-repl.key \
	--network mongo-$VERSION \
	--hostname mongo2 \
	--net-alias mongo2 \
	-p $PORT_2:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=password \
	-d mongo:$VERSION \
	mongod --serviceExecutor adaptive --replSet rs1 --port 27017 --keyFile /etc/mongo-repl.key

docker run --name mongo-cluster-$VERSION-3 --restart=always --user "$(id -u):$(id -g)" \
	-v $DATA_DIR/node3:/data/db \
	-v $CONF_DIR/mongo-repl.key:/etc/mongo-repl.key \
	--network mongo-$VERSION \
	--hostname mongo3 \
	--net-alias mongo3 \
	-p $PORT_3:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=password \
	-d mongo:$VERSION \
	mongod --serviceExecutor adaptive --replSet rs1 --port 27017 --keyFile /etc/mongo-repl.key

echo Waiting for things to start...
sleep 10


echo Intiating replica set...

INIT_JS="
db.auth('root', 'password');
rs.initiate(
    {_id: 'rs1', version: 1,
        members: [
            { _id: 0, host : 'mongo1:27017' },
            { _id: 1, host : 'mongo2:27017' },
            { _id: 2, host : 'mongo3:27017' }
        ]
    }
);
"

echo $INIT_JS


docker exec -it mongo-cluster-$VERSION-1 mongo --username root --password password --host mongo1 --authenticationDatabase admin admin --eval "$INIT_JS"

echo Done

