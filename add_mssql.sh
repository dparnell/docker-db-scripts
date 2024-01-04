#!/bin/sh

VERSION=$1
PORT=$2

DATA_DIR=$HOME/mssql/$VERSION
mkdir -p $DATA_DIR
chown -R 1000:1000 $DATA_DIR

# make a random password as MSSQL does not like a simple password
PASSWORD=`openssl rand -base64 13`
echo $PASSWORD > $DATA_DIR/password.txt

docker run --name mssql-$VERSION --restart=always  --user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro -v $DATA_DIR:/var/opt/mssql -p $PORT:1433 -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$PASSWORD" -d mcr.microsoft.com/mssql/server:$VERSION-latest

echo New MSSQL instance created with sa password $PASSWORD

