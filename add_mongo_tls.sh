#!/bin/sh

VERSION=$1
PORT=$2

BASE_DIR=$HOME/mongo-tls/$VERSION
DATA_DIR=$BASE_DIR/data
mkdir -p $DATA_DIR
CERTS_DIR=$BASE_DIR/certs
mkdir -p $CERTS_DIR


# openssl req -newkey rsa:2048 -nodes -keyout $CERTS_DIR/mongo.key -x509 -days 3650 -subj "/C=AU/ST=Victoria/L=Melbourne/O=Mamori.io/OU=Org/CN=Mongo ${VERSION}" -out $CERTS_DIR/mongo.crt
openssl req -newkey rsa:2048 -nodes -keyout $CERTS_DIR/mongo.key -subj "/C=AU/ST=Victoria/L=Melbourne/O=Mamori.io/OU=Org/CN=Mongo ${VERSION}" -out $CERTS_DIR/mongo.csr
openssl x509 -signkey $CERTS_DIR/mongo.key -in $CERTS_DIR/mongo.csr -req -days 3650 -out $CERTS_DIR/mongo.crt
cat $CERTS_DIR/mongo.crt $CERTS_DIR/mongo.key > $CERTS_DIR/mongo.pem

docker run --name mongo-tls-$VERSION --restart=always --user "$(id -u):$(id -g)" -v $DATA_DIR:/data/db -v $CERTS_DIR:/data/certs -p $PORT:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=password -d mongo:$VERSION --bind_ip_all --tlsMode requireTLS --tlsCertificateKeyFile /data/certs/mongo.pem

